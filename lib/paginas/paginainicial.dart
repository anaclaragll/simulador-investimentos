import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/simulador.dart';
import 'paginaresultado.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final _formKey = GlobalKey<FormState>();
  final _capital1Controller = TextEditingController();
  final _aporte1Controller = TextEditingController();
  final _taxa1Controller = TextEditingController();
  final _capital2Controller = TextEditingController();
  final _aporte2Controller = TextEditingController();
  final _taxa2Controller = TextEditingController();
  final _periodoController = TextEditingController();

  static const _tinta = Color(0xFF26353B);
  static const _azul = Color(0xFF356C83);
  static const _laranja = Color(0xFFCE7838);

  @override
  void dispose() {
    _capital1Controller.dispose();
    _aporte1Controller.dispose();
    _taxa1Controller.dispose();
    _capital2Controller.dispose();
    _aporte2Controller.dispose();
    _taxa2Controller.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  double? _lerNumero(String valor) =>
      double.tryParse(valor.trim().replaceAll(',', '.'));

  String? _validarValorNaoNegativo(String? valor) {
    final numero = valor == null ? null : _lerNumero(valor);
    if (numero == null || !numero.isFinite) {
      return 'Informe um número válido.';
    }
    if (numero < 0) {
      return 'O valor não pode ser negativo.';
    }
    return null;
  }

  String? _validarTaxa(String? valor) {
    final numero = valor == null ? null : _lerNumero(valor);
    if (numero == null || !numero.isFinite) {
      return 'Informe uma taxa válida.';
    }
    if (numero < -100) {
      return 'A taxa não pode ser menor que -100%.';
    }
    return null;
  }

  String? _validarPeriodo(String? valor) {
    final meses = valor == null ? null : int.tryParse(valor.trim());
    if (meses == null) {
      return 'Informe um número inteiro de meses.';
    }
    if (meses < 1 || meses > 600) {
      return 'Use um período entre 1 e 600 meses.';
    }
    return null;
  }

  Future<void> _comparar() async {
    if (!_formKey.currentState!.validate()) return;

    final periodo = int.parse(_periodoController.text.trim());
    final investimento1 = Investimento(
      nome: 'Cenário A',
      capitalInicial: _lerNumero(_capital1Controller.text)!,
      aporteMensal: _lerNumero(_aporte1Controller.text)!,
      taxaMensalPercentual: _lerNumero(_taxa1Controller.text)!,
    );
    final investimento2 = Investimento(
      nome: 'Cenário B',
      capitalInicial: _lerNumero(_capital2Controller.text)!,
      aporteMensal: _lerNumero(_aporte2Controller.text)!,
      taxaMensalPercentual: _lerNumero(_taxa2Controller.text)!,
    );

    final reiniciar = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaginaResultado(
          simulacao1: investimento1.simular(periodo),
          simulacao2: investimento2.simular(periodo),
        ),
      ),
    );

    if (reiniciar == true && mounted) {
      for (final controller in [
        _capital1Controller,
        _aporte1Controller,
        _taxa1Controller,
        _capital2Controller,
        _aporte2Controller,
        _taxa2Controller,
        _periodoController,
      ]) {
        controller.clear();
      }
    }
  }

  Widget _campoCompacto({
    required String chave,
    required TextEditingController controller,
    required String sufixo,
    required String? Function(String?) validar,
    bool decimal = true,
    bool assinado = false,
  }) {
    return TextFormField(
      key: ValueKey(chave),
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: decimal,
        signed: assinado,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\-]')),
      ],
      decoration: InputDecoration(
        suffixText: sufixo,
        filled: true,
        fillColor: const Color(0xFFF9FAF8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCE2E2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCE2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _azul, width: 1.5),
        ),
      ),
      validator: validar,
    );
  }

  Widget _linhaParametro({
    required String nome,
    required String sufixo,
    required String chaveA,
    required String chaveB,
    required TextEditingController controllerA,
    required TextEditingController controllerB,
    required String? Function(String?) validar,
    bool assinado = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 91,
            child: Text(
              nome,
              style: const TextStyle(
                color: _tinta,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: _campoCompacto(
              chave: chaveA,
              controller: controllerA,
              sufixo: sufixo,
              validar: validar,
              assinado: assinado,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _campoCompacto(
              chave: chaveB,
              controller: controllerB,
              sufixo: sufixo,
              validar: validar,
              assinado: assinado,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendimento em números'),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.tune_rounded, color: _azul),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Monte sua comparação',
                style: TextStyle(
                  color: _tinta,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Cada linha é um dado; preencha as duas alternativas lado a lado.',
                style: TextStyle(
                  color: Color(0xFF69747B),
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE0E5E4)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 91),
                        Expanded(
                          child: Center(
                            child: Text(
                              'ALTERNATIVA A',
                              style: TextStyle(
                                color: _azul,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Center(
                            child: Text(
                              'ALTERNATIVA B',
                              style: TextStyle(
                                color: _laranja,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18),
                    _linhaParametro(
                      nome: 'Capital',
                      sufixo: 'R\$',
                      chaveA: 'investimento1_capital',
                      chaveB: 'investimento2_capital',
                      controllerA: _capital1Controller,
                      controllerB: _capital2Controller,
                      validar: _validarValorNaoNegativo,
                    ),
                    _linhaParametro(
                      nome: 'Aporte mensal',
                      sufixo: 'R\$',
                      chaveA: 'investimento1_aporte',
                      chaveB: 'investimento2_aporte',
                      controllerA: _aporte1Controller,
                      controllerB: _aporte2Controller,
                      validar: _validarValorNaoNegativo,
                    ),
                    _linhaParametro(
                      nome: 'Taxa mensal',
                      sufixo: '%',
                      chaveA: 'investimento1_taxa',
                      chaveB: 'investimento2_taxa',
                      controllerA: _taxa1Controller,
                      controllerB: _taxa2Controller,
                      validar: _validarTaxa,
                      assinado: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: _azul,
                    size: 21,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Mesmo prazo para as duas alternativas',
                      style: TextStyle(
                        color: _tinta,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 115,
                    child: _campoCompacto(
                      chave: 'periodo',
                      controller: _periodoController,
                      sufixo: 'meses',
                      validar: _validarPeriodo,
                      decimal: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const ValueKey('comparar_investimentos'),
                onPressed: _comparar,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Calcular rendimentos'),
                style: FilledButton.styleFrom(
                  backgroundColor: _tinta,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

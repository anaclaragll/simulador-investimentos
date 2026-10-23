import 'package:flutter/material.dart';

import '../models/simulador.dart';

class PaginaResultado extends StatelessWidget {
  const PaginaResultado({
    super.key,
    required this.simulacao1,
    required this.simulacao2,
  });

  final Simulacao simulacao1;
  final Simulacao simulacao2;

  static const _tinta = Color(0xFF26353B);
  static const _azul = Color(0xFF356C83);
  static const _laranja = Color(0xFFCE7838);

  static String _formatarMoeda(double valor) {
    final sinal = valor < 0 ? '-' : '';
    final inteiro = valor.abs().truncate().toString();
    final agrupado = StringBuffer();
    for (var i = 0; i < inteiro.length; i++) {
      if (i > 0 && (inteiro.length - i) % 3 == 0) {
        agrupado.write('.');
      }
      agrupado.write(inteiro[i]);
    }
    final centavos = (valor.abs() % 1).toStringAsFixed(2).substring(2);
    return 'R\$ $sinal${agrupado.toString()},$centavos';
  }

  Widget _linhaResumo({
    required Simulacao simulacao,
    required Color cor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 43,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  simulacao.investimento.nome,
                  style: TextStyle(
                    color: cor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Montante ${_formatarMoeda(simulacao.montanteFinal)}',
                  style: const TextStyle(
                    color: _tinta,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Rendimento ${_formatarMoeda(simulacao.rendimentoTotal)}',
                  style: const TextStyle(
                    color: Color(0xFF6C777B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoMes(int indice) {
    final saldoA = simulacao1.evolucaoMensal[indice];
    final saldoB = simulacao2.evolucaoMensal[indice];
    final nomeMes = indice == 0 ? 'Saldo inicial' : 'Mês $indice';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E6E5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nomeMes,
                  style: const TextStyle(
                    color: _tinta,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                indice == 0 ? 'INÍCIO' : '$indiceº MÊS',
                style: const TextStyle(
                  color: Color(0xFF788387),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _valorMes(
                  nome: 'A',
                  valor: saldoA,
                  cor: _azul,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _valorMes(
                  nome: 'B',
                  valor: saldoB,
                  cor: _laranja,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _valorMes({
    required String nome,
    required double valor,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cenário $nome',
            style: TextStyle(
              color: cor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatarMoeda(valor),
              style: const TextStyle(
                color: _tinta,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cabecalho() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'COMPARAÇÃO CONCLUÍDA',
            style: TextStyle(
              color: _azul,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'O que a simulação mostra',
            style: TextStyle(
              color: _tinta,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Prazo: ${simulacao1.evolucaoMensal.length - 1} meses',
            style: const TextStyle(color: Color(0xFF6C777B), fontSize: 13),
          ),
          const SizedBox(height: 12),
          _linhaResumo(simulacao: simulacao1, cor: _azul),
          const Divider(height: 1),
          _linhaResumo(simulacao: simulacao2, cor: _laranja),
          const SizedBox(height: 12),
          const Text(
            'Evolução mensal',
            style: TextStyle(
              color: _tinta,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Cada cartão mostra o saldo dos dois cenários naquele mês.',
            style: TextStyle(
              color: Color(0xFF6C777B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rodape(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Projeção calculada com as taxas informadas; não representa '
            'garantia de rendimento futuro.',
            style: TextStyle(
              color: Color(0xFF6C777B),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            key: const ValueKey('nova_comparacao'),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Fazer nova simulação'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _tinta,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color(0xFFBBC4C8)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMeses = simulacao1.evolucaoMensal.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        title: const Text('Sua projeção'),
        actions: [
          IconButton(
            tooltip: 'Voltar e editar valores',
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        key: const ValueKey('evolucao_mensal'),
        padding: EdgeInsets.zero,
        itemCount: totalMeses + 2,
        itemBuilder: (context, indice) {
          if (indice == 0) return _cabecalho();
          if (indice <= totalMeses) return _cartaoMes(indice - 1);
          return _rodape(context);
        },
      ),
    );
  }
}

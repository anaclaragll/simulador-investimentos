# Rendimento em números

Aplicativo Flutter para simular e comparar dois planos de investimento. Informe
capital inicial, aplicação mensal, taxa de juros e prazo para ver os montantes
finais, rendimentos e a evolução de cada plano mês a mês.

## Funcionalidades

- Formulário para preencher os cenários A e B e o prazo compartilhado.
- Validação de valores e do período (de 1 a 600 meses).
- Resumo comparativo do montante final e do rendimento.
- Lista mensal em cartões, com os saldos dos dois cenários em cada mês.
- Opção de voltar para editar os cenários ou iniciar uma nova comparação.

## Regra de cálculo

Os juros de cada mês incidem sobre o saldo existente no início do mês. A
aplicação mensal é adicionada ao final do mês e começa a render no mês seguinte:

```text
saldo do mês = saldo anterior × (1 + taxa mensal) + aplicação mensal
```

O rendimento total é o montante final menos o capital inicial e a soma de todas
as contribuições mensais. A taxa deve ser informada em porcentagem ao mês (por
exemplo, `1` para `1%`). Os valores exibidos são projeções matemáticas, não
garantias de rentabilidade; a simulação não considera impostos ou inflação.

## Sobre a simulação

O cálculo segue a regra de juros compostos com aplicação mensal descrita acima.
Os cenários são independentes e usam o mesmo prazo para facilitar a comparação.

## Executar

Na pasta do projeto, execute:

```bash
flutter pub get
flutter run
```

Para executar os testes:

```bash
flutter test
```

## Demonstração em vídeo

Para demonstrar o app, preencha os valores lado a lado, compare os resultados,
percorra os cartões mensais e inicie uma nova simulação.

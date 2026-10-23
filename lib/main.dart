import 'package:flutter/material.dart';

import 'paginas/paginainicial.dart';

void main() {
  runApp(const SimuladorInvestimentoApp());
}

class SimuladorInvestimentoApp extends StatelessWidget {
  const SimuladorInvestimentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF356C83);
    const corDestaque = Color(0xFFCE7838);

    return MaterialApp(
      title: 'Rendimento em números',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: corPrincipal,
              primary: corPrincipal,
              secondary: corDestaque,
              surface: const Color(0xFFFFFEFC),
            ).copyWith(
              onSurface: const Color(0xFF25313B),
              onSurfaceVariant: const Color(0xFF69747B),
              outlineVariant: const Color(0xFFD9DDE0),
              surfaceContainerHighest: const Color(0xFFE9EEF0),
              surfaceContainerLow: const Color(0xFFF4F6F6),
            ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F8F5),
          foregroundColor: Color(0xFF25313B),
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}

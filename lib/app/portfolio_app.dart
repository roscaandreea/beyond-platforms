import 'package:material_ui/material_ui.dart';

import '../features/portfolio/portfolio_page.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _dark = true;

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF55B7FF),
          brightness: brightness,
        ).copyWith(
          primary: Color(dark ? 0xFF55B7FF : 0xFF1264AC),
          onPrimary: Color(dark ? 0xFF0B101B : 0xFFFFFFFF),
          secondary: Color(dark ? 0xFF35D7E8 : 0xFF087C89),
          tertiary: Color(dark ? 0xFFB5A2FF : 0xFF7154BB),
          surface: Color(dark ? 0xFF131C2C : 0xFFFFFFFF),
          surfaceContainerHighest: Color(dark ? 0xFF1B2739 : 0xFFE8EDF5),
          onSurface: Color(dark ? 0xFFF4F7FC : 0xFF101828),
          onSurfaceVariant: Color(dark ? 0xFF9CAFC5 : 0xFF526176),
          outline: Color(dark ? 0xFF2A3950 : 0xFFCDD6E3),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Color(dark ? 0xFF0B101B : 0xFFF5F7FB),
      fontFamily: 'Plus Jakarta Sans',
    );
    final text = base.textTheme;
    return base.copyWith(
      textTheme: text.copyWith(
        displayLarge: text.displayLarge?.copyWith(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: text.headlineLarge?.copyWith(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w700,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Beyond Platforms | Andreea Rosca',
    debugShowCheckedModeBanner: false,
    theme: _theme(Brightness.light),
    darkTheme: _theme(Brightness.dark),
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    home: PortfolioPage(onToggleTheme: () => setState(() => _dark = !_dark)),
  );
}

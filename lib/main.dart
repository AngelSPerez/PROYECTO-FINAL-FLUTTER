import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class AppTheme {
  AppTheme._();
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
}

void main() {
  runApp(const RecipeReciveApp());
}

class RecipeReciveApp extends StatefulWidget {
  const RecipeReciveApp({super.key});

  @override
  State<RecipeReciveApp> createState() => _RecipeReciveAppState();
}

class _RecipeReciveAppState extends State<RecipeReciveApp> {
  late ThemeMode _themeMode;
  late final VoidCallback _themeListener;

  @override
  void initState() {
    super.initState();
    _themeMode = AppTheme.mode.value;
    _themeListener = () {
      if (mounted) setState(() => _themeMode = AppTheme.mode.value);
    };
    AppTheme.mode.addListener(_themeListener);
  }

  @override
  void dispose() {
    AppTheme.mode.removeListener(_themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeRecive',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27B0),
        ),
        fontFamily: 'Roboto',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27B0),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF303030),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

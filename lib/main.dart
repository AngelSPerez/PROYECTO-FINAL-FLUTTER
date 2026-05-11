import 'package:flutter/material.dart';
import 'l10n/app_locale.dart';
import 'services/preferences_service.dart';
import 'screens/splash_screen.dart';

class AppTheme {
  AppTheme._();
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  AppLocale.language.value = PreferencesService.getLanguage();
  AppTheme.mode.value = PreferencesService.getThemeMode();
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
  late final VoidCallback _langListener;

  @override
  void initState() {
    super.initState();
    _themeMode = AppTheme.mode.value;
    _themeListener = () {
      PreferencesService.setThemeMode(AppTheme.mode.value);
      if (mounted) setState(() => _themeMode = AppTheme.mode.value);
    };
    _langListener = () {
      PreferencesService.setLanguage(AppLocale.language.value);
      if (mounted) setState(() {});
    };
    AppTheme.mode.addListener(_themeListener);
    AppLocale.language.addListener(_langListener);
  }

  @override
  void dispose() {
    AppTheme.mode.removeListener(_themeListener);
    AppLocale.language.removeListener(_langListener);
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

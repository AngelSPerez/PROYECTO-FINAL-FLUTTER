import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'firebase_options.dart';
import 'l10n/app_locale.dart';
import 'services/preferences_service.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'screens/splash_screen.dart';

class AppTheme {
  AppTheme._();
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferencesService.init();
  await AuthService.instance.init();
  AppLocale.language.value = PreferencesService.getLanguage();
  AppTheme.mode.value = PreferencesService.getThemeMode();

  if (!await AuthService.instance.hasSeeded()) {
    await AuthService.instance.seedAdmin();
    await FirebaseService.instance.seedRecipes();
    await AuthService.instance.markSeeded();
  }

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

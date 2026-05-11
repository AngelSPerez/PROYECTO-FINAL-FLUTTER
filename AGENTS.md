# recipe_recive — agent guide

## Commands

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis (package:flutter_lints/flutter.yaml)
flutter test             # run tests
flutter run              # launch on connected device/emulator
```

## Architecture

- **Entrypoint**: `lib/main.dart` — `RecipeReciveApp`, Material 3 with `ColorScheme.fromSeed(seedColor: Color(0xFF9C27B0))`.
- **Navigation**: raw `Navigator.push`/`pushReplacement`; no router package.
- **State**: `setState` everywhere + `AppTheme.mode` (a `ValueNotifier<ThemeMode>` in `main.dart`) for light/dark/system toggle.
- **Theme config**: `ConfigurationScreen` (`lib/screens/configuration_screen.dart`) writes to `AppTheme.mode.value`.
- **i18n**: `lib/l10n/strings.dart` — `Str` static class reads `AppLocale.language` (`ValueNotifier<String>`) and returns English/Spanish strings.
- **Splash screen**: always in Spanish (hardcoded, not affected by language toggle).
- **Persistence**: `lib/services/preferences_service.dart` wraps `shared_preferences` for theme mode and language. Initialized in `main()` before `runApp`.
- **Models**: `lib/models/recipe.dart` — `Recipe` class + `placeholderRecipes` list (hardcoded data).
- **Screens**: `lib/screens/` — 15 files (splash → welcome → register/login → recipe list/detail + 7 admin sub-screens + config).
- **Shared widgets**: `lib/widgets/app_widgets.dart` (`AppLogo` uses `Image.asset('assets/images/image.png')`, `RecipeImagePlaceholder` used for recipe cards).
- **Page transitions**: custom `FadeUpwardsPageTransitionsBuilder` on all platforms (Android, iOS, Windows, macOS, Linux).
- **Font**: `fontFamily: 'Roboto'` hardcoded in theme but font `.ttf` assets are commented out in `pubspec.yaml` (lines 34–37).

## Gotchas

- **Firebase NOT integrated**: all Firebase/cache dependencies are commented out in `pubspec.yaml` (lines 16–20). Recipes use `placeholderRecipes`, not Firestore.
- **Login is mocked**: `_login()` in `login_screen.dart:36` uses `Future.delayed(500ms)` — no real auth.
- **Test smoke-test only**: `test/widget_test.dart` verifies `RecipeReciveApp` renders without crashing. No widget-level or unit tests exist yet.
- **No custom lint rules**: `analysis_options.yaml` uses the default `package:flutter_lints/flutter.yaml` as-is (no rules enabled or disabled).

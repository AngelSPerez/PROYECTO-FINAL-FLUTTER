# recipe_recive — agent guide

## Commands

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis (uses package:flutter_lints/flutter.yaml)
flutter test             # run tests
flutter run              # launch on connected device/emulator
```

## Architecture

- **Entrypoint**: `lib/main.dart` — `RecipeReciveApp`, Material 3 with `ColorScheme.fromSeed(seedColor: Color(0xFF9C27B0))`.
- **Navigation**: raw `Navigator.push`/`pushReplacement`; no router package.
- **State**: all `setState` — no Provider/Riverpod/BLoC yet.
- **Models**: `lib/models/recipe.dart` — `Recipe` class + `placeholderRecipes` list (hardcoded data).
- **Screens**: `lib/screens/` — 15 files (splash → welcome → register/login → recipe list/detail + admin sub-screens + config).
- **Shared widgets**: `lib/widgets/app_widgets.dart` (`AppLogo`, `RecipeImagePlaceholder`).

## Important gotchas

- **Tests are stale**: `test/widget_test.dart` references `MyApp` (a counter app pattern), not the real `RecipeReciveApp`. Any test additions must use the actual app class.
- **Firebase NOT integrated**: all Firebase/cache dependencies are commented out in `pubspec.yaml` (lines 16–20). Recipes use placeholder data, not Firestore.
- **Login is mocked**: `_login()` in `lib/screens/login_screen.dart:29` uses `Future.delayed(500ms)` — no real auth.
- **Admin flow is broken**: `LoginScreen(isAdmin: true)` still navigates to `RecipeListScreen` (`login_screen.dart:39–42`). `AdminPanelScreen` exists but is unreachable.
- **Assets & fonts**: asset directory and custom font entries are commented out in `pubspec.yaml` (lines 31–38).
- **Images**: all use `RecipeImagePlaceholder` — no `Image.network` or `Image.asset` calls yet.

# recipe_recive — agent guide

## Commands

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis (package:flutter_lints/flutter.yaml)
flutter test             # run tests
flutter run              # launch on connected device/emulator
```

## Architecture

- **Entrypoint**: `lib/main.dart` — `RecipeReciveApp`, Material 3 with `ColorScheme.fromSeed(seedColor: Color(0xFF9C27B0))`. Sets edge-to-edge: `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` + `SystemChrome.setSystemUIOverlayStyle`.
- **Navigation**: raw `Navigator.push`/`pushReplacement`; no router package.
- **State**: `setState` everywhere + `AppTheme.mode` (a `ValueNotifier<ThemeMode>` in `main.dart`) for light/dark/system toggle.
- **Theme config**: `ConfigurationScreen` (`lib/screens/configuration_screen.dart`) writes to `AppTheme.mode.value`. Body wrapped in `SafeArea`.
- **i18n**: `lib/l10n/strings.dart` — `Str` static class reads `AppLocale.language` (`ValueNotifier<String>`) and returns English/Spanish/Portuguese strings.
- **Splash screen**: always in Spanish (hardcoded, not affected by language toggle).
- **Persistence**: `lib/services/preferences_service.dart` wraps `shared_preferences` for theme mode and language. Initialized in `main()` before `runApp`.
- **Models**: `lib/models/recipe.dart` — `Recipe` class + `placeholderRecipes` list (fallback data).
- **Screens**: `lib/screens/` — 17+ files (splash → welcome → register/login → recipe list/detail + 7 admin sub-screens + config + profile + user_items_screen with 4 sub-screens).
- **Shared widgets**: `lib/widgets/app_widgets.dart` (`AppLogo` uses `Image.asset('assets/images/image.png')`, `RecipeImagePlaceholder` used for recipe cards).
- **Page transitions**: custom `FadeUpwardsPageTransitionsBuilder` on all platforms (Android, iOS, Windows, macOS, Linux).
- **Font**: `fontFamily: 'Roboto'` hardcoded in theme but font `.ttf` assets are commented out in `pubspec.yaml` (lines 34–37).
- **Locale-aware state**: `lib/widgets/locale_aware.dart` — `LocaleAwareState` mixin rebuilds when `AppLocale.language` changes.

## Firebase Integration

- **Auth**: `lib/services/auth_service.dart` — `FirebaseAuth` with `signInWithEmailAndPassword`, `createUserWithEmailAndPassword`, `sendPasswordResetEmail`. Real auth (no longer mocked). `changeEmail()` requires password argument for reauthentication.
- **Firestore**: `lib/services/firebase_service.dart` — `FirebaseFirestore` CRUD for `recipes`, `liked`, `saved`, `comments`, `ratings`, `users` collections. Recipes loaded from Firestore with `placeholderRecipes` fallback.
- **Storage**: `FirebaseStorage` for admin image upload via `image_picker`. Uploaded to `gs://recipe-recive.firebasestorage.app/recipe_images/`.
- **Collections schema**:
  - `recipes`: fields — `id` (auto-ID), `idx` (int index), `name`, `description`, `difficulty`, `time`, `image`, `ingredients` (array), `steps` (array), `category`, `servings`
  - `liked`: fields — `user` (display name), `recipeId` (recipe doc ID), `timestamp`
  - `saved`: same structure as `liked`
  - `comments`: fields — `user`, `recipeId`, `text` (nullable), `rating` (int 1-5), `timestamp`
  - `ratings`: fields — `user`, `recipeId`, `rating` (int 1-5), `timestamp`. Written independently when user submits rating via comment sheet.
- **Admin seeding**: `AuthService.seedAdmin()` called on first launch — creates admin@reciperecive.com / Admin123! in Firebase Auth and `users` collection.

## Key Features

- **Edge-to-edge**: Android only — `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` + transparent system bars + dark/light overlay style. `SafeArea` wraps screen bodies to avoid content under system UI.
- **Like/Save persistence**: `_toggleLike`/`_toggleSave` add/delete docs in `liked`/`saved` collections. Queried via `getLikedByUserAndRecipe`/`getSavedByUserAndRecipe` returning `DocumentSnapshot?`.
- **Live average rating**: detail screen computes `_avgRating` from `ratings` collection filtered by `recipeId` via `getRatingsForRecipe` → average of `rating` field.
- **Interactive star rating**: stars in detail screen are tappable → opens existing comment sheet. Rating allowed without text.
- **Like button position**: detail appBar row: back arrow – title – like icon button, `space-between` layout. Old separate like row removed.
- **Recommended chips**: scrollable horizontal list of pill-shaped text chips in "Recommended for you" section. Moves with list/grid scroll (part of the main scroll view).
- **Admin image upload**: admin recipe form has Image URL text field + gallery icon button → `image_picker` → upload to Firebase Storage → fill URL field.
- **Profile screens**: `UserSavedScreen`, `UserLikedScreen`, `UserCommentsScreen`, `UserRatingsScreen` in `lib/screens/user_items_screen.dart`. Each shows recipe image + icon overlay (bookmark/heart/comment/star) + name, tap to detail. `UserRatingsScreen` matches by `recipeId` first, falls back to `recipeIdx`.
- **Change email dialog**: prompts for current password before calling `AuthService.changeEmail()`.

## Important Details

- Like/save use `user` field = `AuthService.instance.currentUser?.name` (Firebase User `displayName` or `email` prefix).
- `recipeId` (Firestore doc ID) preferred over `recipeIdx` for ratings/comments matching to avoid ordering mismatches.
- `addRating` wrapped in try/catch — doesn't break comment submission if rating save fails.
- Admin credentials: admin@reciperecive.com / Admin123!
- Recommended chips only show when `_isRecommendedExpanded` is true (controlled by arrow toggle).

## Gotchas

- **Firebase config**: `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` required for build. Not committed in repo (in `.gitignore`).
- **Test smoke-test only**: `test/widget_test.dart` verifies `RecipeReciveApp` renders without crashing. No widget-level or unit tests exist yet.
- **No custom lint rules**: `analysis_options.yaml` uses the default `package:flutter_lints/flutter.yaml` as-is.
- **Roboto font**: `fontFamily: 'Roboto'` is hardcoded but `.ttf` assets are commented out — falls back to system default.
- **Android build**: requires `minSdkVersion 23` in `android/app/build.gradle` (Firebase requirement).

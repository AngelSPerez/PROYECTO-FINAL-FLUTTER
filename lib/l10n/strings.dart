import 'app_locale.dart';

class Str {
  Str._();

  static String get _l => AppLocale.language.value;
  static bool get _es => _l == 'es';

  // ── Glossary ────────────────────────────────────────────────────────
  static String get cancel => _es ? 'Cancelar' : 'Cancel';
  static String get accept => _es ? 'Aceptar' : 'Accept';
  static String get save => _es ? 'Guardar' : 'Save';
  static String get logOut => _es ? 'Cerrar sesión' : 'Log out';
  static String get logOutShort => _es ? 'Salir' : 'Log out';
  static String get search => _es ? 'Buscar...' : 'Search...';
  static String get email => _es ? 'Correo electrónico' : 'Email';
  static String get password => _es ? 'Contraseña' : 'Password';
  static String get options => _es ? 'Opciones' : 'Options';
  static String get edit => _es ? 'Editar' : 'Edit';
  static String get delete => _es ? 'Eliminar' : 'Delete';
  static String get add => _es ? 'Agregar' : 'Add';
  static String get user => _es ? 'Usuario' : 'User';
  static String get recipe => _es ? 'Receta' : 'Recipe';
  static String get recipePlural => _es ? 'Recetas' : 'Recipes';

  // ── SplashScreen ────────────────────────────────────────────────────
  static String get splashDescription => _es
      ? 'Recetario digital con recetas listas para cocinar en casa. '
          'Pensado para quienes no saben qué preparar, ofrece platillos '
          'organizados por chefs y permite calificar y comentar cada receta.'
      : 'Digital recipe book with recipes ready to cook at home. '
          'Designed for those who don\'t know what to prepare, it offers '
          'dishes organized by chefs and lets you rate and comment on each recipe.';
  static String get userButton => _es ? 'Usuario' : 'User';
  static String get adminButton => _es ? 'Administrador' : 'Administrator';

  // ── WelcomeScreen ───────────────────────────────────────────────────
  static String get welcomeTitle => _es ? 'Bienvenido a\nRecipeRecive' : 'Welcome to\nRecipeRecive';
  static String get getStarted => _es ? 'Comenzar' : 'Get Started';
  static String get logIn => _es ? 'Iniciar sesión' : 'Log In';

  // ── RegisterScreen ──────────────────────────────────────────────────
  static String get nameLabel => _es ? 'Nombre:' : 'Name:';
  static String get emailLabel => _es ? 'Correo electrónico:' : 'E-mail:';
  static String get passwordLabel => _es ? 'Contraseña:' : 'Password:';
  static String get enterName => _es ? 'Ingresa tu nombre' : 'Please enter your name';
  static String get enterEmail => _es ? 'Ingresa tu correo' : 'Please enter your email';
  static String get validEmail => _es ? 'Ingresa un correo válido' : 'Enter a valid email';
  static String get enterPassword => _es ? 'Ingresa una contraseña' : 'Please enter a password';
  static String get passwordMinLength => _es ? 'Mínimo 6 caracteres' : 'Password must be at least 6 characters';
  static String get register => _es ? 'Registrarse' : 'Register';

  // ── LoginScreen ─────────────────────────────────────────────────────
  static String get adminTitle => _es ? 'Admin' : 'Admin';
  static String get logInButton => _es ? 'Iniciar sesión' : 'Log In';

  // ── RecipeListScreen ────────────────────────────────────────────────
  static String get filters => _es ? 'Filtros' : 'Filters';
  static String get favorites => _es ? 'Favoritos' : 'Favorites';
  static String get noRecipesFound => _es ? 'No se encontraron recetas.' : 'No recipes found.';
  static String get logOutConfirmTitle => _es ? 'Cerrar sesión' : 'Log out';
  static String get logOutConfirmBody => _es
      ? '¿Seguro que quieres cerrar sesión?'
      : 'Are you sure you want to log out?';

  // ── RecipeDetailScreen ──────────────────────────────────────────────
  static String get preparation => _es ? 'Preparación:' : 'Preparation:';
  static String get cooking => _es ? 'Cocción:' : 'Cooking:';
  static String get total => _es ? 'Total:' : 'Total:';
  static String get ingredients => _es ? 'Ingredientes' : 'Ingredients';
  static String get steps => _es ? 'Pasos' : 'Steps';
  static String get meGusta => _es ? 'Me gusta' : 'Like';
  static String get teGusta => _es ? 'Te gusta' : 'You like this';
  static String get shareRecipe => _es ? 'Compartir receta' : 'Share recipe';
  static String get message => _es ? 'Mensaje' : 'Message';
  static String get copy => _es ? 'Copiar' : 'Copy';
  static String get more => _es ? 'Más' : 'More';
  static String get shoppingList => _es ? 'Lista de compras' : 'Shopping list';
  static String get addAll => _es ? 'Agregar todo' : 'Add all';
  static String get comments => _es ? 'Comentarios' : 'Comments';
  static String get writeComment => _es ? 'Escribe un comentario...' : 'Write a comment...';
  static String get send => _es ? 'Enviar' : 'Send';
  static String get you => _es ? 'Tú' : 'You';
  static String get now => _es ? 'Ahora' : 'Now';

  // ── UserProfileScreen ───────────────────────────────────────────────
  static String get saved => _es ? 'Guardados' : 'Saved';
  static String get liked => _es ? 'Gustados' : 'Liked';
  static String get commented => _es ? 'Comentados' : 'Commented';
  static String get rates => _es ? 'Calificaciones' : 'Rates';
  static String get configuration => _es ? 'Configuración' : 'Configuration';

  // ── ConfigurationScreen ─────────────────────────────────────────────
  static String get configurationTitle => _es ? 'Configuración' : 'Configuration';
  static String get language => _es ? 'Idioma' : 'Language';
  static String get theme => _es ? 'Tema' : 'Theme';
  static String get aboutUs => _es ? 'Acerca de' : 'About us';
  static String get changePassword => _es ? 'Cambiar contraseña' : 'Change password';
  static String get changeEmail => _es ? 'Cambiar correo' : 'Change E-mail';
  static String get english => _es ? 'Inglés' : 'English';
  static String get spanish => _es ? 'Español' : 'Spanish';
  static String get light => _es ? 'Claro' : 'Light';
  static String get dark => _es ? 'Oscuro' : 'Dark';
  static String get system => _es ? 'Sistema' : 'System';
  static String get currentPassword => _es ? 'Contraseña actual' : 'Current password';
  static String get newPassword => _es ? 'Nueva contraseña' : 'New password';
  static String get confirmPassword => _es ? 'Confirmar contraseña' : 'Confirm password';
  static String get newEmail => _es ? 'Nuevo correo' : 'New e-mail';
  static String get passwordUpdated => _es ? 'Contraseña actualizada' : 'Password updated';
  static String get emailUpdated => _es ? 'Correo actualizado' : 'E-mail updated';
  static String get aboutText => _es
      ? 'ReciveRecipe es un recetario digital para entusiastas de la '
          'cocina casera. Descubre, guarda y comparte tus recetas favoritas.\n\nVersión 1.0.0'
      : 'ReciveRecipe is a digital recipe book for home cooking '
          'enthusiasts. Discover, save, and share your favourite recipes.\n\nVersion 1.0.0';
  static String get close => _es ? 'Cerrar' : 'Close';

  // ── AdminPanelScreen ────────────────────────────────────────────────
  static String get adminPanel => _es ? 'Panel de administración' : 'Admin panel';
  static String get users => _es ? 'Usuarios' : 'Users';
  static String get ratings => _es ? 'Calificaciones' : 'Ratings';
  static String get savedPlural => _es ? 'Guardados' : 'Saved';

  // ── AdminRecipesScreen ──────────────────────────────────────────────
  static String get searchRecipe => _es ? 'Buscar receta...' : 'Search recipe...';
  static String get newRecipe => _es ? 'Nueva receta' : 'New recipe';
  static String get editRecipe => _es ? 'Editar receta' : 'Edit recipe';
  static String get deleteRecipe => _es ? 'Eliminar receta' : 'Delete recipe';
  static String get title => _es ? 'Título' : 'Title';
  static String get prepTime => _es ? 'Tiempo de preparación' : 'Prep time';
  static String get cookTime => _es ? 'Tiempo de cocción' : 'Cook time';
  static String get totalTime => _es ? 'Tiempo total' : 'Total time';
  static String get ingredientsComma => _es
      ? 'Ingredientes (separados por coma)'
      : 'Ingredients (comma separated)';
  static String get stepsOnePerLine => _es ? 'Pasos (uno por línea)' : 'Steps (one per line)';
  static String get rating => _es ? 'Calificación' : 'Rating';
  static String deletedRecipe(String title) =>
      _es ? '"$title" eliminada' : '"$title" deleted';

  // ── AdminCommentsScreen ─────────────────────────────────────────────
  static String get searchComment => _es
      ? 'Buscar por usuario, receta o texto...'
      : 'Search by user, recipe or text...';
  static String get noCommentsYet => _es ? 'Sin comentarios aún' : 'No comments yet';
  static String get newComment => _es ? 'Nuevo comentario' : 'New comment';
  static String get editComment => _es ? 'Editar comentario' : 'Edit comment';
  static String get comment => _es ? 'Comentario' : 'Comment';
  static String get commentDeleted => _es ? 'Comentario eliminado' : 'Comment deleted';

  // ── AdminUsersScreen ────────────────────────────────────────────────
  static String get searchUser => _es ? 'Buscar usuario...' : 'Search user...';
  static String get noUsersFound => _es ? 'No se encontraron usuarios' : 'No users found';
  static String get newUser => _es ? 'Nuevo usuario' : 'New user';
  static String get editUser => _es ? 'Editar usuario' : 'Edit user';
  static String get name => _es ? 'Nombre' : 'Name';
  static String get role => _es ? 'Rol' : 'Role';
  static String get admin => _es ? 'Admin' : 'Admin';
  static String get removeAdmin => _es ? 'Quitar rol admin' : 'Remove admin role';
  static String get makeAdmin => _es ? 'Hacer administrador' : 'Make admin';
  static String get deleteUser => _es ? 'Eliminar usuario' : 'Delete user';
  static String deletedUser(String name) =>
      _es ? 'Usuario "$name" eliminado' : 'User "$name" deleted';

  // ── AdminRatingsScreen ──────────────────────────────────────────────
  static String get searchUserOrRecipe => _es
      ? 'Buscar por usuario o receta...'
      : 'Search by user or recipe...';
  static String get noRatingsYet => _es ? 'Sin calificaciones aún' : 'No ratings yet';
  static String get newRating => _es ? 'Nueva calificación' : 'New rating';
  static String get editRating => _es ? 'Editar calificación' : 'Edit rating';
  static String get ratingDeleted => _es ? 'Calificación eliminada' : 'Rating deleted';

  // ── AdminSavedScreen ────────────────────────────────────────────────
  static String get noEntries => _es ? 'Sin registros' : 'No entries';
  static String get newEntry => _es ? 'Agregar entrada' : 'Add entry';
  static String get editEntry => _es ? 'Editar entrada' : 'Edit entry';
  static String get deleteEntry => _es ? 'Eliminar entrada' : 'Delete entry';
  static String get entryDeleted => _es ? 'Entrada eliminada' : 'Entry deleted';

  // ── AdminLikedScreen ────────────────────────────────────────────────
  static String get newLikedEntry => _es ? 'Agregar gustado' : 'Add liked';
  static String get editLikedEntry => _es ? 'Editar entrada' : 'Edit entry';

  // ── Recipe data translations ──────────────────────────────────────────────
  static String recipeTitle(String en) {
    if (!_es) return en;
    return _recipeTitles[en] ?? en;
  }

  static String ingredient(String en) {
    if (!_es) return en;
    return _ingredients[en] ?? en;
  }

  static String step(String en) {
    if (!_es) return en;
    return _steps[en] ?? en;
  }

  static const _recipeTitles = <String, String>{
    'Apple Pie': 'Pay de manzana',
    'Chicken': 'Pollo',
    'Cheesecake': 'Pastel de queso',
    'Cookies': 'Galletas',
    'Wings': 'Alitas',
    'Pasta': 'Pasta',
    'Tacos': 'Tacos',
    'Pancakes': 'Panqueques',
  };

  static const _ingredients = <String, String>{
    'Apple': 'Manzana',
    'Flour': 'Harina',
    'Sugar': 'Azúcar',
    'Butter': 'Mantequilla',
    'Cinnamon': 'Canela',
    'Chicken leg': 'Pierna de pollo',
    'Garlic': 'Ajo',
    'Olive oil': 'Aceite de oliva',
    'Salt': 'Sal',
    'Black pepper': 'Pimienta negra',
    'Paprika': 'Paprika',
    'Cream cheese': 'Queso crema',
    'Eggs': 'Huevos',
    'Vanilla extract': 'Extracto de vainilla',
    'Graham crackers': 'Galletas Graham',
    'Brown sugar': 'Azúcar morena',
    'Chocolate chips': 'Chispas de chocolate',
    'Hot sauce': 'Salsa picante',
    'Garlic powder': 'Ajo en polvo',
    'Spaghetti': 'Espagueti',
    'Tomato sauce': 'Salsa de tomate',
    'Parmesan': 'Parmesano',
    'Basil': 'Albahaca',
    'Corn tortillas': 'Tortillas de maíz',
    'Ground beef': 'Carne molida',
    'Onion': 'Cebolla',
    'Cilantro': 'Cilantro',
    'Lime': 'Limón',
    'Salsa': 'Salsa',
    'Baking powder': 'Polvo para hornear',
    'Maple syrup': 'Jarabe de arce',
    'Milk': 'Leche',
    'Cumin': 'Comino',
    'Chili powder': 'Chile en polvo',
  };

  static const _steps = <String, String>{
    'Preheat oven to 180°C.': 'Precalienta el horno a 180°C.',
    'Mix flour and butter to make the dough.': 'Mezcla la harina con la mantequilla para hacer la masa.',
    'Peel and slice apples, toss with sugar and cinnamon.': 'Pela y rebana las manzanas, mezcla con azúcar y canela.',
    'Line pie dish with dough, add filling, cover with top crust.': 'Forra el molde con masa, agrega el relleno, cubre con la tapa.',
    'Bake for 45 minutes until golden.': 'Hornea 45 minutos hasta que esté dorado.',
    'Season chicken with salt, pepper and paprika.': 'Sazona el pollo con sal, pimienta y paprika.',
    'Heat olive oil in a pan over medium-high heat.': 'Calienta aceite de oliva en una sartén a fuego medio-alto.',
    'Cook chicken for 12 minutes per side until golden.': 'Cocina el pollo 12 minutos por lado hasta que dore.',
    'Rest for 5 minutes before serving.': 'Reposa 5 minutos antes de servir.',
    'Crush crackers and mix with melted butter. Press into pan.': 'Tritura las galletas y mezcla con mantequilla derretida. Presiona en el molde.',
    'Beat cream cheese with sugar until smooth.': 'Bate el queso crema con el azúcar hasta que esté suave.',
    'Add eggs and vanilla, mix well.': 'Agrega los huevos y la vainilla, mezcla bien.',
    'Pour over crust and bake at 160°C for 1 hour.': 'Vierte sobre la base y hornea a 160°C por 1 hora.',
    'Refrigerate overnight before serving.': 'Refrigera toda la noche antes de servir.',
    'Preheat oven to 175°C.': 'Precalienta el horno a 175°C.',
    'Cream butter and sugars together.': 'Bate la mantequilla con los azúcares.',
    'Beat in eggs and vanilla.': 'Incorpora los huevos y la vainilla.',
    'Mix in flour, then fold in chocolate chips.': 'Agrega la harina, luego incorpora las chispas de chocolate.',
    'Drop spoonfuls on baking sheet and bake 10–12 minutes.': 'Coloca cucharadas en una bandeja y hornea 10–12 minutos.',
    'Pat wings dry, season with salt and garlic powder.': 'Seca las alitas, sazona con sal y ajo en polvo.',
    'Bake at 200°C for 45 minutes, flipping halfway.': 'Hornea a 200°C por 45 minutos, volteando a la mitad.',
    'Melt butter and mix with hot sauce.': 'Derrite la mantequilla y mezcla con salsa picante.',
    'Toss baked wings in sauce and serve immediately.': 'Baña las alitas horneadas en la salsa y sirve de inmediato.',
    'Boil pasta in salted water per package directions.': 'Hierve la pasta en agua con sal según las instrucciones.',
    'Sauté garlic in olive oil, add tomato sauce, simmer 10 min.': 'Sofríe el ajo en aceite de oliva, agrega salsa de tomate, cocina 10 min.',
    'Drain pasta and toss with sauce.': 'Escurre la pasta y mezcla con la salsa.',
    'Top with Parmesan and fresh basil.': 'Cubre con parmesano y albahaca fresca.',
    'Cook ground beef with diced onion until browned.': 'Cocina la carne molida con cebolla picada hasta que dore.',
    'Season with cumin, chili powder, salt.': 'Sazona con comino, chile en polvo y sal.',
    'Warm tortillas on a dry pan.': 'Calienta las tortillas en un comal.',
    'Assemble with beef, cilantro, salsa and a squeeze of lime.': 'Arma con la carne, cilantro, salsa y un poco de limón.',
    'Whisk dry ingredients together.': 'Mezcla los ingredientes secos.',
    'Mix wet ingredients separately, then combine both.': 'Mezcla los ingredientes húmedos por separado, luego combínalos.',
    'Cook on buttered griddle, 2–3 min per side.': 'Cocina en un comal enmantequillado, 2–3 min por lado.',
    'Serve with maple syrup and extra butter.': 'Sirve con jarabe de arce y mantequilla extra.',
  };
}

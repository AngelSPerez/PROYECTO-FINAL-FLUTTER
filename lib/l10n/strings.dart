import 'app_locale.dart';

class Str {
  Str._();

  static String get _l => AppLocale.language.value;
  static bool get _es => _l == 'es';
  static bool get _pt => _l == 'pt_BR';

  // ── Glossary ────────────────────────────────────────────────────────
  static String get cancel => _pt ? 'Cancelar' : _es ? 'Cancelar' : 'Cancel';
  static String get accept => _pt ? 'Aceitar' : _es ? 'Aceptar' : 'Accept';
  static String get save => _pt ? 'Salvar' : _es ? 'Guardar' : 'Save';
  static String get logOut => _pt ? 'Sair' : _es ? 'Cerrar sesión' : 'Log out';
  static String get logOutShort => _pt ? 'Sair' : _es ? 'Salir' : 'Log out';
  static String get search => _pt ? 'Pesquisar...' : _es ? 'Buscar...' : 'Search...';
  static String get email => _pt ? 'E-mail' : _es ? 'Correo electrónico' : 'Email';
  static String get password => _pt ? 'Senha' : _es ? 'Contraseña' : 'Password';
  static String get options => _pt ? 'Opções' : _es ? 'Opciones' : 'Options';
  static String get edit => _pt ? 'Editar' : _es ? 'Editar' : 'Edit';
  static String get delete => _pt ? 'Excluir' : _es ? 'Eliminar' : 'Delete';
  static String get add => _pt ? 'Adicionar' : _es ? 'Agregar' : 'Add';
  static String get user => _pt ? 'Usuário' : _es ? 'Usuario' : 'User';
  static String get recipe => _pt ? 'Receita' : _es ? 'Receta' : 'Recipe';
  static String get recipePlural => _pt ? 'Receitas' : _es ? 'Recetas' : 'Recipes';

  // ── SplashScreen ────────────────────────────────────────────────────
  static String get splashDescription => _pt
      ? 'Livro de receitas digital com receitas prontas para cozinhar em '
          'casa. Pensado para quem não sabe o que preparar, oferece pratos '
          'organizados por chefs e permite avaliar e comentar cada receita.'
      : _es
          ? 'Recetario digital con recetas listas para cocinar en casa. '
              'Pensado para quienes no saben qué preparar, ofrece platillos '
              'organizados por chefs y permite calificar y comentar cada receta.'
          : 'Digital recipe book with recipes ready to cook at home. '
              'Designed for those who don\'t know what to prepare, it offers '
              'dishes organized by chefs and lets you rate and comment on each recipe.';
  static String get userButton => _pt ? 'Usuário' : _es ? 'Usuario' : 'User';
  static String get adminButton => _pt ? 'Administrador' : _es ? 'Administrador' : 'Administrator';

  // ── RoleChoiceScreen ───────────────────────────────────────────────────
  static String get roleChoiceTitle =>
      _pt ? 'Quem é você?' : _es ? '¿Quién eres?' : 'Who are you?';
  static String get roleChoiceSubtitle =>
      _pt ? 'Selecione como deseja entrar' : _es ? 'Selecciona cómo deseas ingresar' : 'Select how you would like to proceed';

  // ── WelcomeScreen ───────────────────────────────────────────────────
  static String get welcomeTitle => _pt
      ? 'Bem-vindo ao\nRecipeRecive'
      : _es
          ? 'Bienvenido a\nRecipeRecive'
          : 'Welcome to\nRecipeRecive';
  static String get getStarted => _pt ? 'Começar' : _es ? 'Comenzar' : 'Get Started';
  static String get logIn => _pt ? 'Entrar' : _es ? 'Iniciar sesión' : 'Log In';

  // ── RegisterScreen ──────────────────────────────────────────────────
  static String get nameLabel => _pt ? 'Nome:' : _es ? 'Nombre:' : 'Name:';
  static String get emailLabel => _pt ? 'E-mail:' : _es ? 'Correo electrónico:' : 'E-mail:';
  static String get passwordLabel => _pt ? 'Senha:' : _es ? 'Contraseña:' : 'Password:';
  static String get enterName => _pt ? 'Insira seu nome' : _es ? 'Ingresa tu nombre' : 'Please enter your name';
  static String get enterEmail => _pt ? 'Insira seu e-mail' : _es ? 'Ingresa tu correo' : 'Please enter your email';
  static String get validEmail => _pt ? 'Insira um e-mail válido' : _es ? 'Ingresa un correo válido' : 'Enter a valid email';
  static String get enterPassword => _pt ? 'Insira uma senha' : _es ? 'Ingresa una contraseña' : 'Please enter a password';
  static String get passwordMinLength => _pt ? 'Mínimo 6 caracteres' : _es ? 'Mínimo 6 caracteres' : 'Password must be at least 6 characters';
  static String get register => _pt ? 'Registrar' : _es ? 'Registrarse' : 'Register';

  // ── LoginScreen ─────────────────────────────────────────────────────
  static String get adminTitle => _pt ? 'Admin' : _es ? 'Admin' : 'Admin';
  static String get logInButton => _pt ? 'Entrar' : _es ? 'Iniciar sesión' : 'Log In';

  // ── RecipeListScreen ────────────────────────────────────────────────
  static String get filters => _pt ? 'Filtros' : _es ? 'Filtros' : 'Filters';
  static String get favorites => _pt ? 'Favoritos' : _es ? 'Favoritos' : 'Favorites';
  static String get noRecipesFound => _pt ? 'Nenhuma receita encontrada.' : _es ? 'No se encontraron recetas.' : 'No recipes found.';
  static String get logOutConfirmTitle => _pt ? 'Sair' : _es ? 'Cerrar sesión' : 'Log out';
  static String get logOutConfirmBody => _pt
      ? 'Tem certeza que deseja sair?'
      : _es
          ? '¿Seguro que quieres cerrar sesión?'
          : 'Are you sure you want to log out?';

  // ── RecipeDetailScreen ──────────────────────────────────────────────
  static String get preparation => _pt ? 'Preparo:' : _es ? 'Preparación:' : 'Preparation:';
  static String get cooking => _pt ? 'Cozimento:' : _es ? 'Cocción:' : 'Cooking:';
  static String get total => _pt ? 'Total:' : _es ? 'Total:' : 'Total:';
  static String get ingredients => _pt ? 'Ingredientes' : _es ? 'Ingredientes' : 'Ingredients';
  static String get steps => _pt ? 'Passos' : _es ? 'Pasos' : 'Steps';
  static String get meGusta => _pt ? 'Curtir' : _es ? 'Me gusta' : 'Like';
  static String get teGusta => _pt ? 'Você curtiu' : _es ? 'Te gusta' : 'You like this';
  static String get shareRecipe => _pt ? 'Compartilhar receita' : _es ? 'Compartir receta' : 'Share recipe';
  static String get message => _pt ? 'Mensagem' : _es ? 'Mensaje' : 'Message';
  static String get copy => _pt ? 'Copiar' : _es ? 'Copiar' : 'Copy';
  static String get more => _pt ? 'Mais' : _es ? 'Más' : 'More';
  static String get shoppingList => _pt ? 'Lista de compras' : _es ? 'Lista de compras' : 'Shopping list';
  static String get addAll => _pt ? 'Adicionar tudo' : _es ? 'Agregar todo' : 'Add all';
  static String get comments => _pt ? 'Comentários' : _es ? 'Comentarios' : 'Comments';
  static String get writeComment => _pt ? 'Escreva um comentário...' : _es ? 'Escribe un comentario...' : 'Write a comment...';
  static String get send => _pt ? 'Enviar' : _es ? 'Enviar' : 'Send';
  static String get you => _pt ? 'Você' : _es ? 'Tú' : 'You';
  static String get now => _pt ? 'Agora' : _es ? 'Ahora' : 'Now';

  // ── UserProfileScreen ───────────────────────────────────────────────
  static String get saved => _pt ? 'Salvos' : _es ? 'Guardados' : 'Saved';
  static String get liked => _pt ? 'Curtidos' : _es ? 'Gustados' : 'Liked';
  static String get commented => _pt ? 'Comentados' : _es ? 'Comentados' : 'Commented';
  static String get rates => _pt ? 'Avaliações' : _es ? 'Calificaciones' : 'Rates';
  static String get configuration => _pt ? 'Configuração' : _es ? 'Configuración' : 'Configuration';

  // ── ConfigurationScreen ─────────────────────────────────────────────
  static String get configurationTitle => _pt ? 'Configuração' : _es ? 'Configuración' : 'Configuration';
  static String get language => _pt ? 'Idioma' : _es ? 'Idioma' : 'Language';
  static String get theme => _pt ? 'Tema' : _es ? 'Tema' : 'Theme';
  static String get aboutUs => _pt ? 'Sobre nós' : _es ? 'Acerca de' : 'About us';
  static String get changePassword => _pt ? 'Alterar senha' : _es ? 'Cambiar contraseña' : 'Change password';
  static String get changeEmail => _pt ? 'Alterar e-mail' : _es ? 'Cambiar correo' : 'Change E-mail';
  static String get english => _pt ? 'Inglês' : _es ? 'Inglés' : 'English';
  static String get spanish => _pt ? 'Espanhol' : _es ? 'Español' : 'Spanish';
  static String get portuguese => _pt ? 'Português (Brasil)' : _es ? 'Portugués (Brasil)' : 'Portuguese (Brazil)';
  static String get light => _pt ? 'Claro' : _es ? 'Claro' : 'Light';
  static String get dark => _pt ? 'Escuro' : _es ? 'Oscuro' : 'Dark';
  static String get system => _pt ? 'Sistema' : _es ? 'Sistema' : 'System';
  static String get currentPassword => _pt ? 'Senha atual' : _es ? 'Contraseña actual' : 'Current password';
  static String get newPassword => _pt ? 'Nova senha' : _es ? 'Nueva contraseña' : 'New password';
  static String get confirmPassword => _pt ? 'Confirmar senha' : _es ? 'Confirmar contraseña' : 'Confirm password';
  static String get newEmail => _pt ? 'Novo e-mail' : _es ? 'Nuevo correo' : 'New e-mail';
  static String get passwordUpdated => _pt ? 'Senha atualizada' : _es ? 'Contraseña actualizada' : 'Password updated';
  static String get emailUpdated => _pt ? 'E-mail atualizado' : _es ? 'Correo actualizado' : 'E-mail updated';
  static String get aboutText => _pt
      ? 'ReciveRecipe é um livro de receitas digital para entusiastas da '
          'culinária caseira. Descubra, salve e compartilhe suas receitas '
          'favoritas.\n\nVersão 1.0.0'
      : _es
          ? 'ReciveRecipe es un recetario digital para entusiastas de la '
              'cocina casera. Descubre, guarda y comparte tus recetas favoritas.\n\nVersión 1.0.0'
          : 'ReciveRecipe is a digital recipe book for home cooking '
              'enthusiasts. Discover, save, and share your favourite recipes.\n\nVersion 1.0.0';
  static String get close => _pt ? 'Fechar' : _es ? 'Cerrar' : 'Close';

  // ── AdminPanelScreen ────────────────────────────────────────────────
  static String get adminPanel => _pt ? 'Painel de administração' : _es ? 'Panel de administración' : 'Admin panel';
  static String get users => _pt ? 'Usuários' : _es ? 'Usuarios' : 'Users';
  static String get ratings => _pt ? 'Avaliações' : _es ? 'Calificaciones' : 'Ratings';
  static String get savedPlural => _pt ? 'Salvos' : _es ? 'Guardados' : 'Saved';

  // ── AdminRecipesScreen ──────────────────────────────────────────────
  static String get searchRecipe => _pt ? 'Pesquisar receita...' : _es ? 'Buscar receta...' : 'Search recipe...';
  static String get newRecipe => _pt ? 'Nova receita' : _es ? 'Nueva receta' : 'New recipe';
  static String get editRecipe => _pt ? 'Editar receita' : _es ? 'Editar receta' : 'Edit recipe';
  static String get deleteRecipe => _pt ? 'Excluir receita' : _es ? 'Eliminar receta' : 'Delete recipe';
  static String get title => _pt ? 'Título' : _es ? 'Título' : 'Title';
  static String get prepTime => _pt ? 'Tempo de preparo' : _es ? 'Tiempo de preparación' : 'Prep time';
  static String get cookTime => _pt ? 'Tempo de cozimento' : _es ? 'Tiempo de cocción' : 'Cook time';
  static String get totalTime => _pt ? 'Tempo total' : _es ? 'Tiempo total' : 'Total time';
  static String get ingredientsComma => _pt
      ? 'Ingredientes (separados por vírgula)'
      : _es
          ? 'Ingredientes (separados por coma)'
          : 'Ingredients (comma separated)';
  static String get stepsOnePerLine => _pt ? 'Passos (um por linha)' : _es ? 'Pasos (uno por línea)' : 'Steps (one per line)';
  static String get rating => _pt ? 'Avaliação' : _es ? 'Calificación' : 'Rating';
  static String deletedRecipe(String title) => _pt
      ? '"$title" excluída'
      : _es
          ? '"$title" eliminada'
          : '"$title" deleted';

  // ── AdminCommentsScreen ─────────────────────────────────────────────
  static String get searchComment => _pt
      ? 'Pesquisar por usuário, receita ou texto...'
      : _es
          ? 'Buscar por usuario, receta o texto...'
          : 'Search by user, recipe or text...';
  static String get noCommentsYet => _pt ? 'Sem comentários ainda' : _es ? 'Sin comentarios aún' : 'No comments yet';
  static String get newComment => _pt ? 'Novo comentário' : _es ? 'Nuevo comentario' : 'New comment';
  static String get editComment => _pt ? 'Editar comentário' : _es ? 'Editar comentario' : 'Edit comment';
  static String get comment => _pt ? 'Comentário' : _es ? 'Comentario' : 'Comment';
  static String get commentDeleted => _pt ? 'Comentário excluído' : _es ? 'Comentario eliminado' : 'Comment deleted';

  // ── AdminUsersScreen ────────────────────────────────────────────────
  static String get searchUser => _pt ? 'Pesquisar usuário...' : _es ? 'Buscar usuario...' : 'Search user...';
  static String get noUsersFound => _pt ? 'Nenhum usuário encontrado' : _es ? 'No se encontraron usuarios' : 'No users found';
  static String get newUser => _pt ? 'Novo usuário' : _es ? 'Nuevo usuario' : 'New user';
  static String get editUser => _pt ? 'Editar usuário' : _es ? 'Editar usuario' : 'Edit user';
  static String get name => _pt ? 'Nome' : _es ? 'Nombre' : 'Name';
  static String get role => _pt ? 'Função' : _es ? 'Rol' : 'Role';
  static String get admin => _pt ? 'Admin' : _es ? 'Admin' : 'Admin';
  static String get removeAdmin => _pt ? 'Remover função admin' : _es ? 'Quitar rol admin' : 'Remove admin role';
  static String get makeAdmin => _pt ? 'Tornar administrador' : _es ? 'Hacer administrador' : 'Make admin';
  static String get deleteUser => _pt ? 'Excluir usuário' : _es ? 'Eliminar usuario' : 'Delete user';
  static String deletedUser(String name) => _pt
      ? 'Usuário "$name" excluído'
      : _es
          ? 'Usuario "$name" eliminado'
          : 'User "$name" deleted';

  // ── AdminRatingsScreen ──────────────────────────────────────────────
  static String get searchUserOrRecipe => _pt
      ? 'Pesquisar por usuário ou receita...'
      : _es
          ? 'Buscar por usuario o receta...'
          : 'Search by user or recipe...';
  static String get noRatingsYet => _pt ? 'Sem avaliações ainda' : _es ? 'Sin calificaciones aún' : 'No ratings yet';
  static String get newRating => _pt ? 'Nova avaliação' : _es ? 'Nueva calificación' : 'New rating';
  static String get editRating => _pt ? 'Editar avaliação' : _es ? 'Editar calificación' : 'Edit rating';
  static String get ratingDeleted => _pt ? 'Avaliação excluída' : _es ? 'Calificación eliminada' : 'Rating deleted';

  // ── AdminSavedScreen ────────────────────────────────────────────────
  static String get noEntries => _pt ? 'Sem registros' : _es ? 'Sin registros' : 'No entries';
  static String get newEntry => _pt ? 'Adicionar entrada' : _es ? 'Agregar entrada' : 'Add entry';
  static String get editEntry => _pt ? 'Editar entrada' : _es ? 'Editar entrada' : 'Edit entry';
  static String get deleteEntry => _pt ? 'Excluir entrada' : _es ? 'Eliminar entrada' : 'Delete entry';
  static String get entryDeleted => _pt ? 'Entrada excluída' : _es ? 'Entrada eliminada' : 'Entry deleted';

  // ── AdminLikedScreen ────────────────────────────────────────────────
  static String get newLikedEntry => _pt ? 'Adicionar curtido' : _es ? 'Agregar gustado' : 'Add liked';
  static String get editLikedEntry => _pt ? 'Editar entrada' : _es ? 'Editar entrada' : 'Edit entry';

  // ── Recommendations ────────────────────────────────────────────────
  static String get recommendedForYou => _pt
      ? 'Recomendado para você'
      : _es
          ? 'Recomendado para ti'
          : 'Recommended for you';
  static String get similarRecipes => _pt
      ? 'Receitas semelhantes'
      : _es
          ? 'Recetas similares'
          : 'Similar recipes';
}

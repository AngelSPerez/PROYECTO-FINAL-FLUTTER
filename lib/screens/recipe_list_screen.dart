import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/app_widgets.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';
import 'user_profile_screen.dart';
import 'recipe_detail_screen.dart';
import 'splash_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;
  bool _showFavoritesOnly = false;

  final List<Recipe> _recipes = placeholderRecipes;

  List<Recipe> get _filtered {
    List<Recipe> result = _recipes;
    if (_showFavoritesOnly) {
      result = result.where((r) => r.isLiked).toList();
    }
    final q = _searchController.text.toLowerCase().trim();
    if (q.isNotEmpty) {
      result = result.where((r) => r.title.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Str.logOutConfirmTitle),
        content: Text(Str.logOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(Str.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            child: Text(Str.logOutShort, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white, size: 28),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserProfileScreen()),
          ),
        ),
        title: const Text(
          'RecipeRecive',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_outlined : Icons.grid_view_outlined,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: Str.search,
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  tooltip: Str.filters,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                    color: _showFavoritesOnly ? Colors.red : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  tooltip: Str.favorites,
                  onPressed: () =>
                      setState(() => _showFavoritesOnly = !_showFavoritesOnly),
                ),
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      Str.noRecipesFound,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                        fontSize: 16,
                      ),
                    ),
                  )
                : _isGridView
                    ? _GridView(
                        recipes: filtered,
                        onTap: _openDetail,
                        onLike: _toggleLike,
                      )
                    : _ListView(
                        recipes: filtered,
                        onTap: _openDetail,
                        onLike: _toggleLike,
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        tooltip: Str.logOutShort,
        onPressed: _confirmLogout,
        child: Icon(Icons.logout, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  void _openDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(
        recipe: recipe,
        allRecipes: _recipes,
      )),
    );
  }

  void _toggleLike(Recipe recipe) {
    setState(() => recipe.isLiked = !recipe.isLiked);
  }
}

class _ListView extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) onTap;
  final void Function(Recipe) onLike;

  const _ListView({
    required this.recipes,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 12, endIndent: 12),
      itemBuilder: (_, i) {
        final r = recipes[i];
        return InkWell(
          onTap: () => onTap(r),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                RecipeImagePlaceholder(
                  width: 82,
                  height: 82,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Str.recipeTitle(r.title),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r.totalTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    r.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: r.isLiked ? Colors.red : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 26,
                  ),
                  onPressed: () => onLike(r),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GridView extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) onTap;
  final void Function(Recipe) onLike;

  const _GridView({
    required this.recipes,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (_, i) {
        final r = recipes[i];
        return Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => onTap(r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: Center(
                          child: Icon(Icons.restaurant, size: 44, color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => onLike(r),
                          child: Icon(
                            r.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: r.isLiked ? Colors.red : Colors.white,
                            size: 22,
                            shadows: [
                              Shadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.26), blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Str.recipeTitle(r.title),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r.totalTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

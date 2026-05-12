import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/app_widgets.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';
import '../utils/recommendations.dart';
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
  final List<Recipe> _recipes = [];

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseService.instance.streamRecipes().listen((recipes) {
      if (mounted) setState(() => _recipes
        ..clear()
        ..addAll(recipes));
    });
  }

  Future<void> _refreshRecipes() async {
    final recipes = await FirebaseService.instance.getRecipes();
    if (mounted) setState(() => _recipes
      ..clear()
      ..addAll(recipes));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

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

  List<Recipe> get _recommended {
    final liked = _recipes.where((r) => r.isLiked).toList();
    return Recommendations.getRecommendedRecipes(_recipes, liked);
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
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.instance.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            child:           Text(Str.logOutShort, style: const TextStyle(color: Colors.red)),
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
            onPressed: _refreshRecipes,
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
                        recommended: _recommended,
                        onTap: _openDetail,
                        onLike: _toggleLike,
                      )
                    : _ListView(
                        recipes: filtered,
                        recommended: _recommended,
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

  Future<void> _toggleLike(Recipe recipe) async {
    final user = AuthService.instance.currentUser?.name ?? '';
    if (user.isEmpty) return;
    final idx = _recipes.indexWhere((r) => r.id == recipe.id);
    if (idx < 0) return;
    final existing = await FirebaseService.instance.getLikedByUserAndRecipe(user, idx);
    if (existing != null) {
      await FirebaseService.instance.deleteLiked(existing['id'] as String);
    } else {
      await FirebaseService.instance.addLiked({'user': user, 'recipeIdx': idx});
    }
    setState(() => recipe.isLiked = !recipe.isLiked);
  }
}

class _ListView extends StatelessWidget {
  final List<Recipe> recipes;
  final List<Recipe> recommended;
  final void Function(Recipe) onTap;
  final void Function(Recipe) onLike;

  const _ListView({
    required this.recipes,
    required this.recommended,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final showRecommended = recommended.isNotEmpty;
    return ListView.separated(
      itemCount: recipes.length + (showRecommended ? 1 : 0),
      separatorBuilder: (_, i) {
        if (showRecommended && i == 0) return const SizedBox.shrink();
        return const Divider(height: 1, indent: 12, endIndent: 12);
      },
      itemBuilder: (_, i) {
        if (showRecommended && i == 0) {
          return _RecommendedSection(recipes: recommended, onTap: onTap);
        }
        final r = recipes[showRecommended ? i - 1 : i];
        return InkWell(
          onTap: () => onTap(r),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                r.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(r.imageUrl!, width: 82, height: 82, fit: BoxFit.cover),
                      )
                    : RecipeImagePlaceholder(
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
                        r.title,
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
  final List<Recipe> recommended;
  final void Function(Recipe) onTap;
  final void Function(Recipe) onLike;

  const _GridView({
    required this.recipes,
    required this.recommended,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (recommended.isNotEmpty)
          SliverToBoxAdapter(
            child: _RecommendedSection(recipes: recommended, onTap: onTap),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
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
                            r.imageUrl != null
                                ? Image.network(r.imageUrl!, fit: BoxFit.cover)
                                : Container(
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
                                r.title,
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
              childCount: recipes.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) onTap;

  const _RecommendedSection({
    required this.recipes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
          child: Text(
            Str.recommendedForYou,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final r = recipes[i];
              return GestureDetector(
                onTap: () => onTap(r),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    r.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

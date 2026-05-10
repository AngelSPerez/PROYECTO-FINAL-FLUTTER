import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/app_widgets.dart';
import 'user_profile_screen.dart';
import 'recipe_detail_screen.dart';
import 'splash_screen.dart';

/// Main recipe list screen.
/// TODO: Replace [placeholderRecipes] with a real Firestore stream.
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;
  bool _showFavoritesOnly = false;

  // TODO: Replace with StreamBuilder<QuerySnapshot> from Firestore
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
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            child: const Text('Log out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white, size: 28),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserProfileScreen()),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                value: _showFavoritesOnly,
                dropdownColor: const Color(0xFF9C27B0),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: false,
                    child: Text('All',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Text('Favorites',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
                onChanged: (v) => setState(() => _showFavoritesOnly = v ?? false),
              ),
            ),
            Text(
              ' (${filtered.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.search, color: Colors.black38),
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
                  icon: const Icon(Icons.tune, color: Colors.black54),
                  tooltip: 'Filters',
                  onPressed: () {
                    // TODO: Show filter bottom sheet
                  },
                ),
                IconButton(
                  icon: Icon(
                    _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                    color: _showFavoritesOnly ? Colors.red : Colors.black54,
                  ),
                  tooltip: 'Favorites',
                  onPressed: () =>
                      setState(() => _showFavoritesOnly = !_showFavoritesOnly),
                ),
              ],
            ),
          ),

          // Recipe list / grid
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No recipes found.',
                      style: TextStyle(color: Colors.black45, fontSize: 16),
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
        backgroundColor: Colors.white,
        elevation: 2,
        tooltip: 'Log out',
        onPressed: _confirmLogout,
        child: const Icon(Icons.logout, color: Colors.black87),
      ),
    );
  }

  void _openDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
  }

  void _toggleLike(Recipe recipe) {
    setState(() => recipe.isLiked = !recipe.isLiked);
  }
}

// ─────────────────────────────────────────────
// List view
// ─────────────────────────────────────────────

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
                // Thumbnail placeholder
                // TODO: Replace with Image.network(r.imageUrl!, fit: BoxFit.cover)
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
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    r.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: r.isLiked ? Colors.red : Colors.black38,
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

// ─────────────────────────────────────────────
// Grid view
// ─────────────────────────────────────────────

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => onTap(r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // TODO: Replace with Image.network(r.imageUrl!, fit: BoxFit.cover)
                      Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.restaurant, size: 44, color: Colors.grey),
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
                            shadows: const [
                              Shadow(color: Colors.black26, blurRadius: 4),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
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
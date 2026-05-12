import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/recipe.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';
import '../widgets/app_widgets.dart';
import 'recipe_detail_screen.dart';

class UserSavedScreen extends StatefulWidget {
  final List<Recipe> recipes;
  const UserSavedScreen({super.key, required this.recipes});
  @override
  State<UserSavedScreen> createState() => _UserSavedScreenState();
}

class _UserSavedScreenState extends State<UserSavedScreen> with LocaleAwareState {
  List<Map<String, dynamic>> _items = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseService.instance.streamSaved().listen((items) {
      if (mounted) setState(() => _items = items);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      final idx = e['recipeIdx'] as int? ?? -1;
      return idx >= 0 && idx < widget.recipes.length;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.saved, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: filtered.isEmpty
          ? Center(child: Text(Str.noEntries, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final idx = filtered[i]['recipeIdx'] as int? ?? -1;
                final recipe = widget.recipes[idx];
                return _RecipeCard(
                  recipe: recipe,
                  icon: Icons.bookmark,
                  iconColor: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe, allRecipes: widget.recipes))),
                );
              },
            ),
    );
  }
}

class UserLikedScreen extends StatefulWidget {
  final List<Recipe> recipes;
  const UserLikedScreen({super.key, required this.recipes});
  @override
  State<UserLikedScreen> createState() => _UserLikedScreenState();
}

class _UserLikedScreenState extends State<UserLikedScreen> with LocaleAwareState {
  List<Map<String, dynamic>> _items = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseService.instance.streamLiked().listen((items) {
      if (mounted) setState(() => _items = items);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      final idx = e['recipeIdx'] as int? ?? -1;
      return idx >= 0 && idx < widget.recipes.length;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.liked, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: filtered.isEmpty
          ? Center(child: Text(Str.noEntries, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final idx = filtered[i]['recipeIdx'] as int? ?? -1;
                final recipe = widget.recipes[idx];
                return _RecipeCard(
                  recipe: recipe,
                  icon: Icons.favorite,
                  iconColor: Colors.redAccent,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe, allRecipes: widget.recipes))),
                );
              },
            ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? trailing;

  const _RecipeCard({
    required this.recipe,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    recipe.imageUrl != null
                        ? Image.network(recipe.imageUrl!, fit: BoxFit.cover)
                        : const RecipeImagePlaceholder(),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Icon(icon, color: iconColor, size: 20, shadows: const [Shadow(color: Colors.black26, blurRadius: 3)]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                recipe.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2), size: 20),
          ],
        ),
      ),
    );
  }
}

class UserCommentsScreen extends StatefulWidget {
  final List<Recipe> recipes;
  const UserCommentsScreen({super.key, required this.recipes});
  @override
  State<UserCommentsScreen> createState() => _UserCommentsScreenState();
}

class _UserCommentsScreenState extends State<UserCommentsScreen> with LocaleAwareState {
  List<Map<String, dynamic>> _items = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseService.instance.streamComments().listen((items) {
      if (mounted) setState(() => _items = items);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.commented, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: _items.isEmpty
          ? Center(child: Text(Str.noCommentsYet, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = _items[i];
                final idx2 = widget.recipes.indexWhere((r) => r.id == c['recipeId']);
                final recipe = idx2 >= 0 ? widget.recipes[idx2] : null;
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline, size: 18)),
                  title: Text('${c['text']}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(recipe?.title ?? '', style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (((c['rating'] as num?)?.toDouble() ?? 0) > 0) ...[
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(' ${c['rating']}', style: const TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                  onTap: recipe != null
                      ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe, allRecipes: widget.recipes)))
                      : null,
                );
              },
            ),
    );
  }
}

class UserRatingsScreen extends StatefulWidget {
  final List<Recipe> recipes;
  const UserRatingsScreen({super.key, required this.recipes});
  @override
  State<UserRatingsScreen> createState() => _UserRatingsScreenState();
}

class _UserRatingsScreenState extends State<UserRatingsScreen> with LocaleAwareState {
  List<Map<String, dynamic>> _items = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseService.instance.streamRatings().listen((items) {
      if (mounted) setState(() => _items = items);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Recipe? _findRecipe(Map<String, dynamic> entry) {
    final id = entry['recipeId'] as String?;
    if (id != null) {
      final i = widget.recipes.indexWhere((r) => r.id == id);
      if (i >= 0) return widget.recipes[i];
    }
    final idx = entry['recipeIdx'] as int? ?? -1;
    if (idx >= 0 && idx < widget.recipes.length) return widget.recipes[idx];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = <({Recipe recipe, num stars})>[];
    for (final e in _items) {
      final recipe = _findRecipe(e);
      if (recipe == null) continue;
      filtered.add((recipe: recipe, stars: e['stars'] as num? ?? 0));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.rates, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: filtered.isEmpty
          ? Center(child: Text(Str.noRatingsYet, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final entry = filtered[i];
                return _RecipeCard(
                  recipe: entry.recipe,
                  icon: Icons.star,
                  iconColor: Colors.amber,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: entry.recipe, allRecipes: widget.recipes))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.stars.toString(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
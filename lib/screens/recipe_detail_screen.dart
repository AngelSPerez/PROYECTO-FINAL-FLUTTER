import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/app_widgets.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';
import '../utils/recommendations.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final List<Recipe> allRecipes;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.allRecipes,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> with LocaleAwareState {
  late Recipe _recipe;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Recipe> _suggestions = [];

  final TextEditingController _commentController = TextEditingController();
  double _userRating = 0.0;
  double _myRating = 0.0;
  String? _ratingDocId;
  double _avgRating = 0.0;
  int _ratingCount = 0;
  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> _ratingsList = [];
  StreamSubscription? _commentsSub;
  StreamSubscription? _ratingsSub;

  @override
  void initState() {
    super.initState();
    _recipe = Recipe(
      id: widget.recipe.id,
      titleEn: widget.recipe.titleEn,
      titleEs: widget.recipe.titleEs,
      prepTime: widget.recipe.prepTime,
      cookTime: widget.recipe.cookTime,
      totalTime: widget.recipe.totalTime,
      ingredientsEn: widget.recipe.ingredientsEn,
      ingredientsEs: widget.recipe.ingredientsEs,
      stepsEn: widget.recipe.stepsEn,
      stepsEs: widget.recipe.stepsEs,
      rating: widget.recipe.rating,
      isLiked: false,
      isSaved: false,
      imageUrl: widget.recipe.imageUrl,
    );

    _commentsSub = FirebaseService.instance.streamComments().listen((comments) {
      if (mounted) setState(() {
        _comments = comments.where((c) => c['recipeId'] == _recipe.id).toList();
      });
    });
    _ratingsSub = FirebaseService.instance.streamRatings().listen((ratings) {
      if (mounted) setState(() {
        _ratingsList = ratings;
        _calcAvgRating();
      });
    });
  }

  void _calcAvgRating() {
    final user = AuthService.instance.currentUser?.name;
    final ratings = _ratingsList.where((r) => r['recipeId'] == _recipe.id).toList();
    _ratingCount = ratings.length;
    _avgRating = _ratingCount > 0
        ? ratings.fold(0.0, (sum, r) => sum + ((r['stars'] as num?)?.toDouble() ?? 0)) / _ratingCount
        : 0.0;

    _myRating = 0.0;
    _ratingDocId = null;
    if (user != null) {
      for (final r in ratings) {
        if (r['user'] == user) {
          _myRating = (r['stars'] as num?)?.toDouble() ?? 0.0;
          _ratingDocId = r['id'] as String?;
          break;
        }
      }
    }
  }

  Future<void> _refreshRecipeDetail() async {
    final all = await FirebaseService.instance.getRecipes();
    final updated = all.where((r) => r.id == _recipe.id).firstOrNull;
    if (updated != null && mounted) {
      setState(() {
        _recipe = Recipe(
          id: updated.id,
          titleEn: updated.titleEn,
          titleEs: updated.titleEs,
          prepTime: updated.prepTime,
          cookTime: updated.cookTime,
          totalTime: updated.totalTime,
          ingredientsEn: updated.ingredientsEn,
          ingredientsEs: updated.ingredientsEs,
          stepsEn: updated.stepsEn,
          stepsEs: updated.stepsEs,
          rating: updated.rating,
          isLiked: _recipe.isLiked,
          isSaved: _recipe.isSaved,
          imageUrl: updated.imageUrl,
        );
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _commentController.dispose();
    _commentsSub?.cancel();
    _ratingsSub?.cancel();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    final user = AuthService.instance.currentUser?.name ?? '';
    if (user.isEmpty) return;
    final idx = widget.allRecipes.indexWhere((r) => r.id == _recipe.id);
    if (idx < 0) return;
    final existing = await FirebaseService.instance.getLikedByUserAndRecipe(user, idx);
    if (existing != null) {
      await FirebaseService.instance.deleteLiked(existing['id'] as String);
    } else {
      await FirebaseService.instance.addLiked({'user': user, 'recipeIdx': idx});
    }
    setState(() => _recipe.isLiked = !_recipe.isLiked);
  }

  Future<void> _toggleSave() async {
    final user = AuthService.instance.currentUser?.name ?? '';
    if (user.isEmpty) return;
    final idx = widget.allRecipes.indexWhere((r) => r.id == _recipe.id);
    if (idx < 0) return;
    final existing = await FirebaseService.instance.getSavedByUserAndRecipe(user, idx);
    if (existing != null) {
      await FirebaseService.instance.deleteSaved(existing['id'] as String);
    } else {
      await FirebaseService.instance.addSaved({
        'user': user,
        'recipeIdx': idx,
        'savedAt': Str.now,
      });
    }
    setState(() => _recipe.isSaved = !_recipe.isSaved);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (value.length >= 3) {
        _suggestions = widget.allRecipes
            .where((r) => r.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        _suggestions = [];
      }
    });
  }

  void _showCommentSheet() {
    _userRating = _myRating;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CommentSheet(
        comments: _comments,
        controller: _commentController,
        userRating: _userRating,
        onRatingChanged: (v) => _userRating = v,
        onSubmit: () async {
          if (_commentController.text.trim().isEmpty && _userRating == 0) return;
          final text = _commentController.text.trim();
          if (text.isNotEmpty) {
            await FirebaseService.instance.addComment({
              'user': Str.you,
              'text': text,
              'time': Str.now,
              'rating': _userRating,
              'recipeId': _recipe.id,
            });
          }
          if (_userRating > 0) {
            final name = AuthService.instance.currentUser?.name ?? Str.you;
            try {
              if (_ratingDocId != null) {
                await FirebaseService.instance.updateRating(_ratingDocId!, {
                  'stars': _userRating,
                });
              } else {
                final docRef = await FirebaseService.instance.addRating({
                  'user': name,
                  'stars': _userRating,
                  'recipeId': _recipe.id,
                });
                _ratingDocId = docRef;
              }

              final myComment = _comments.cast<Map<String, dynamic>?>().firstWhere(
                (c) => c?['user'] == Str.you,
                orElse: () => null,
              );
              if (myComment != null && text.isEmpty) {
                await FirebaseService.instance.updateComment(myComment['id'] as String, {
                  'rating': _userRating,
                });
              }

              _myRating = _userRating;
            } catch (_) {}
          }
          _commentController.clear();
          _userRating = 0;
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Str.shareRecipe,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareOption(icon: Icons.message, label: Str.message),
                _ShareOption(icon: Icons.email_outlined, label: Str.email),
                _ShareOption(icon: Icons.copy, label: Str.copy),
                _ShareOption(icon: Icons.more_horiz, label: Str.more),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showShoppingList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).padding.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Str.shoppingList,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._recipe.ingredients.map(
                (ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 18, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 8),
                      Expanded(child: Text(ing)),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag, size: 20),
                        color: const Color(0xFF9C27B0),
                        tooltip: 'Buy',
                        onPressed: () => _buyIngredient(ing),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buyIngredient(String ingredient) async {
    final encoded = Uri.encodeQueryComponent(ingredient);
    final url = Uri.parse('https://www.google.com/search?q=$encoded');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open browser for $ingredient')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshRecipeDetail,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: Str.search,
                hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.38)),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                prefixIcon: Icon(Icons.search, color: scheme.onSurface.withValues(alpha: 0.38)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          _recipe.imageUrl != null
                              ? Image.network(
                                  _recipe.imageUrl!,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                )
                              : const RecipeImagePlaceholder(
                                  width: double.infinity,
                                  height: 220,
                                ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _toggleSave,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _recipe.isSaved
                                      ? Colors.orange
                                      : Colors.orange.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  _recipe.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const SizedBox(
                                width: 40,
                                child: Icon(Icons.arrow_back, size: 22),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _recipe.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: GestureDetector(
                                onTap: _toggleLike,
                                child: Icon(
                                  _recipe.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _recipe.isLiked ? Colors.red : scheme.outline,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      _TimeRow(label: Str.preparation, value: _recipe.prepTime),
                      _TimeRow(label: Str.cooking, value: _recipe.cookTime),
                      _TimeRow(label: Str.total, value: _recipe.totalTime),

                      const SizedBox(height: 12),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: scheme.tertiaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Str.ingredients,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                _ActionButton(icon: Icons.share, onTap: _showShareSheet),
                                const SizedBox(width: 6),
                                _ActionButton(icon: Icons.chat_bubble_outline, onTap: _showCommentSheet),
                                const SizedBox(width: 6),
                                _ActionButton(icon: Icons.shopping_cart_outlined, onTap: _showShoppingList),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ..._recipe.ingredients.map(
                                  (ing) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: 6, color: scheme.onSurface.withValues(alpha: 0.6)),
                                        const SizedBox(width: 6),
                                        Text(ing),
                                      ],
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ...List.generate(5, (i) {
                                  final fill = _myRating > 0
                                      ? i < _myRating.round()
                                      : i < _avgRating.round();
                                  return GestureDetector(
                                    onTap: () {
                                      _userRating = (i + 1).toDouble();
                                      _showCommentSheet();
                                    },
                                    child: Icon(
                                      fill ? Icons.star : Icons.star_border,
                                      color: _myRating > 0
                                          ? Colors.amber
                                          : Colors.amber,
                                      size: 20,
                                    ),
                                  );
                                }),
                                const SizedBox(width: 6),
                                Text(
                                  _avgRating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (_ratingCount > 0)
                                  Text(
                                    ' ($_ratingCount)',
                                    style: TextStyle(fontSize: 12, color: scheme.outline),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Str.steps,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ..._recipe.steps.asMap().entries.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF9C27B0),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${e.key + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(e.value)),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                    ),

                    _SimilarRecipesSection(
                      recipes: Recommendations.getSimilarRecipes(_recipe, widget.allRecipes),
                      onTap: (r) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              recipe: r,
                              allRecipes: widget.allRecipes,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),

                if (_searchQuery.length >= 3 && _suggestions.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 2,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (_, i) {
                          final r = _suggestions[i];
                          return InkWell(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _suggestions = [];
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailScreen(
                                    recipe: r,
                                    allRecipes: widget.allRecipes,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Text(r.title,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final String value;

  const _TimeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 6),
          Text('$label $value', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ShareOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _CommentSheet extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final TextEditingController controller;
  final double userRating;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;

  const _CommentSheet({
    required this.comments,
    required this.controller,
    required this.userRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.userRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Str.comments,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...widget.comments.map(
              (c) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 14)),
                        const SizedBox(width: 6),
                        Text(c['user'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Spacer(),
                        if (((c['rating'] as num?)?.toDouble() ?? 0) > 0) ...[
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(' ${c['rating']}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                        const SizedBox(width: 4),
                        Text(c['time'] ?? '',
                            style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${c['text']}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),

            Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _rating = i + 1.0);
                    widget.onRatingChanged(i + 1.0);
                  },
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: Str.writeComment,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: widget.onSubmit,
                  child: Text(Str.send),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SimilarRecipesSection extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) onTap;

  const _SimilarRecipesSection({
    required this.recipes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            Str.similarRecipes,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final r = recipes[i];
              return GestureDetector(
                onTap: () => onTap(r),
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: r.imageUrl != null
                              ? Image.network(r.imageUrl!, width: 140, fit: BoxFit.cover)
                              : Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                  child: Center(
                                    child: Icon(Icons.restaurant, size: 28, color: Theme.of(context).colorScheme.outline),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 12, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    r.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              );
            },
          ),
        ),
      ],
    );
  }
}

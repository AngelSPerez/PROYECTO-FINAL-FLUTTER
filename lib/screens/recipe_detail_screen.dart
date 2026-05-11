import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/app_widgets.dart';
import 'user_profile_screen.dart';

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

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Recipe> _suggestions = [];

  // Comment form
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 0;
  final List<Map<String, dynamic>> _comments = [
    {
      'user': 'Angel Salinas',
      'text': 'Quedó increíble, la masa crujiente y el relleno suave. ¡Muy recomendado!',
      'time': '1h',
      'rating': 4.5,
    }
  ];

  @override
  void initState() {
    super.initState();
    // Clone recipe so local mutations (like/save) don't affect the list
    _recipe = Recipe(
      id: widget.recipe.id,
      title: widget.recipe.title,
      prepTime: widget.recipe.prepTime,
      cookTime: widget.recipe.cookTime,
      totalTime: widget.recipe.totalTime,
      ingredients: widget.recipe.ingredients,
      steps: widget.recipe.steps,
      rating: widget.recipe.rating,
      isLiked: false,   // always start cleared
      isSaved: false,
      imageUrl: widget.recipe.imageUrl,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() => setState(() => _recipe.isLiked = !_recipe.isLiked);
  void _toggleSave() => setState(() => _recipe.isSaved = !_recipe.isSaved);

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
        onRatingChanged: (v) => setState(() => _userRating = v),
        onSubmit: () {
          if (_commentController.text.trim().isEmpty) return;
          setState(() {
            _comments.insert(0, {
              'user': 'Tú',
              'text': _commentController.text.trim(),
              'time': 'Ahora',
              'rating': _userRating,
            });
            _commentController.clear();
            _userRating = 0;
          });
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
      builder: (_) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Compartir receta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareOption(icon: Icons.message, label: 'Mensaje'),
                _ShareOption(icon: Icons.email_outlined, label: 'Email'),
                _ShareOption(icon: Icons.copy, label: 'Copiar'),
                _ShareOption(icon: Icons.more_horiz, label: 'Más'),
              ],
            ),
            SizedBox(height: 16),
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
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de compras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._recipe.ingredients.map(
              (ing) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 18, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(width: 8),
                    Text(ing),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Agregar todo'),
              ),
            ),
          ],
        ),
      ),
    );
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Fixed search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
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

          // Content with overlay suggestions
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe image with bookmark badge
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

                      // Back + title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back, size: 22),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _recipe.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Times
                      _TimeRow(label: 'Preparation:', value: _recipe.prepTime),
                      _TimeRow(label: 'Cooking:', value: _recipe.cookTime),
                      _TimeRow(label: 'Total:', value: _recipe.totalTime),

                      const SizedBox(height: 12),

                      // Ingredients + action buttons
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
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            ..._recipe.ingredients.take(3).map(
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
                                Text(
                                  _recipe.rating.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Steps
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Steps',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

                      // Like button at bottom
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _recipe.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(_recipe.isLiked),
                                  color: _recipe.isLiked ? Colors.red : scheme.outline,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _recipe.isLiked ? 'Te gusta' : 'Me gusta',
                              style: TextStyle(
                                color: _recipe.isLiked ? Colors.red : scheme.outline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
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

// ── Time row ────────────────────────────────────────────────────────────────
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

// ── Action button (share / comment / cart) ──────────────────────────────────
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

// ── Share option chip ────────────────────────────────────────────────────────
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

// ── Comment bottom sheet ─────────────────────────────────────────────────────
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
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.userRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comentarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Existing comments
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
                        if ((c['rating'] as double) > 0) ...[
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(' ${c['rating']}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                        const SizedBox(width: 4),
                        Text(c['time'],
                            style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c['text'], style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),

            // Star rating
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

            // Text input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
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
                  child: const Text('Enviar'),
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
import 'package:flutter/material.dart';
import '../models/recipe.dart';

/// Recipe detail screen.
/// TODO: Fetch real recipe data from Firestore by [recipe.id].
/// TODO: Replace image placeholder with Image.network(recipe.imageUrl!).
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool _isSaved;
  late bool _isLiked;
  int _selectedTab = 0; // 0 = Ingredients, 1 = Steps, 2 = Comments
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSaved = widget.recipe.isSaved;
    _isLiked = widget.recipe.isLiked;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header image ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF9C27B0),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // TODO: Replace with Image.network(recipe.imageUrl!, fit: BoxFit.cover)
                  Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    ),
                  ),
                  // Bookmark button
                  Positioned(
                    top: 52,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSaved = !_isSaved;
                          widget.recipe.isSaved = _isSaved;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + Title row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Like button
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.black45,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            widget.recipe.isLiked = _isLiked;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Time rows
                  _TimeRow(label: 'Preparation:', value: recipe.prepTime),
                  const SizedBox(height: 6),
                  _TimeRow(label: 'Cooking:', value: recipe.cookTime),
                  const SizedBox(height: 6),
                  _TimeRow(label: 'Total:', value: recipe.totalTime),
                  const SizedBox(height: 20),

                  // Info card (Ingredients / Steps / Comments)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                          child: Row(
                            children: [
                              // Tab labels
                              Expanded(
                                child: Wrap(
                                  spacing: 8,
                                  children: [
                                    _TabChip(
                                      label: 'Ingredients',
                                      selected: _selectedTab == 0,
                                      onTap: () => setState(() => _selectedTab = 0),
                                    ),
                                    _TabChip(
                                      label: 'Steps',
                                      selected: _selectedTab == 1,
                                      onTap: () => setState(() => _selectedTab = 1),
                                    ),
                                    _TabChip(
                                      label: 'Comments',
                                      selected: _selectedTab == 2,
                                      onTap: () => setState(() => _selectedTab = 2),
                                    ),
                                  ],
                                ),
                              ),
                              // Action icons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _CircleIconButton(
                                    icon: Icons.share_outlined,
                                    onTap: () {
                                      // TODO: Share recipe
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  _CircleIconButton(
                                    icon: Icons.chat_bubble_outline,
                                    onTap: () =>
                                        setState(() => _selectedTab = 2),
                                  ),
                                  const SizedBox(width: 4),
                                  _CircleIconButton(
                                    icon: Icons.shopping_cart_outlined,
                                    onTap: () {
                                      // TODO: Add ingredients to shopping list
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Rating row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                recipe.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                            ],
                          ),
                        ),
                        const Divider(indent: 16, endIndent: 16),

                        // Tab content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: _buildTabContent(recipe),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(Recipe recipe) {
    switch (_selectedTab) {
      case 0: // Ingredients
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recipe.ingredients
              .map(
                (ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16, height: 1.4)),
                      Expanded(
                        child: Text(ing, style: const TextStyle(fontSize: 15, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );

      case 1: // Steps
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recipe.steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
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
                      '${entry.key + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      case 2: // Comments
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Load comments from Firestore
            const Text(
              'No comments yet. Be the first!',
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(
                hintText: 'Write a comment…',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color(0xFF9C27B0), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Post comment to Firestore
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Post'),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────

class _TimeRow extends StatelessWidget {
  final String label;
  final String value;
  const _TimeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          '$label $value',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight:
              selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.black87 : Colors.black38,
          decoration:
              selected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
            )
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.black54),
      ),
    );
  }
}
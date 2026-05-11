import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'admin_recipes_screen.dart';
import 'admin_users_screen.dart';
import 'admin_comments_screen.dart';
import 'admin_ratings_screen.dart';
import 'admin_saved_screen.dart';
import 'admin_liked_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminPanelScreen({
    super.key,
    required this.recipes,
  });

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant,
                color: Color(0xFF9C27B0),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Panel de administrador',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = (constraints.maxWidth - 14) / 2;
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: const _RecipeBookIcon(),
                      label: 'Recetas',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminRecipesScreen(
                            recipes: widget.recipes,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: 'Usuarios',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUsersScreen(),
                        ),
                      ),
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: 'Comentarios',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminCommentsScreen(),
                        ),
                      ),
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: const Icon(
                        Icons.star,
                        size: 64,
                        color: Colors.amber,
                      ),
                      label: 'Calificaciones',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminRatingsScreen(
                            recipes: widget.recipes,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: Icon(
                        Icons.bookmark_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: 'Guardados',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminSavedScreen(
                            recipes: widget.recipes,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: const Icon(
                        Icons.favorite,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                      label: 'Gustados',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminLikedScreen(
                            recipes: widget.recipes,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sizedCard({required double size, required Widget child}) {
    return SizedBox(width: size, height: size, child: child);
  }
}

class _AdminCard extends StatelessWidget {
  final Widget content;
  final String label;
  final VoidCallback onTap;

  const _AdminCard({
    required this.content,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeBookIcon extends StatelessWidget {
  const _RecipeBookIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 64, color: Colors.red[700]),
          const Positioned(
            top: 8,
            child: Icon(Icons.soup_kitchen, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

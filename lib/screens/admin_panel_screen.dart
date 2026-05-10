import 'package:flutter/material.dart';

/// Administrator panel screen.
/// TODO: Wire each card to its respective admin management screen
///       and add Firebase auth check to ensure only admins can access.
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        automaticallyImplyLeading: false,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _showMore ? _buildMoreGrid() : _buildMainGrid(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Material(
          color: const Color(0xFF9C27B0),
          child: InkWell(
            onTap: () {
              if (_showMore) {
                setState(() => _showMore = false);
              } else {
                Navigator.pop(context);
              }
            },
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Volver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Main 2×2 grid ─────────────────────────────────────────────────────────
  Widget _buildMainGrid() {
    return Column(
      children: [
        Expanded(
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
                      content: _RecipeBookIcon(),
                      label: 'Recetas',
                      onTap: () {
                        // TODO: Admin recipe management
                      },
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: const Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Colors.black87,
                      ),
                      label: 'Usuarios',
                      onTap: () {
                        // TODO: Admin user management
                      },
                    ),
                  ),
                  _sizedCard(
                    size: size,
                    child: _AdminCard(
                      content: const Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.black87,
                      ),
                      label: 'Comentarios',
                      onTap: () {
                        // TODO: Admin comment management
                      },
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
                      onTap: () {
                        // TODO: Admin ratings management
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _showMore = true),
          child: const Text(
            'Ver mas...',
            style: TextStyle(color: Colors.black45, fontSize: 15),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── "Ver mas" extended grid ────────────────────────────────────────────────
  Widget _buildMoreGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = (constraints.maxWidth - 14) / 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: _AdminCard(
                    content: const Icon(
                      Icons.bookmark_outline,
                      size: 64,
                      color: Colors.black87,
                    ),
                    label: 'Guardados',
                    onTap: () {
                      // TODO: Admin saved management
                    },
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: _AdminCard(
                    content: const Icon(
                      Icons.favorite,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    label: 'Gustados',
                    onTap: () {
                      // TODO: Admin liked management
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: _AdminCard(
                content: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.black87,
                ),
                label: 'Comentarios',
                onTap: () {
                  // TODO: Admin comment management
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sizedCard({required double size, required Widget child}) {
    return SizedBox(width: size, height: size, child: child);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable card widget
// ─────────────────────────────────────────────────────────────────────────────
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recipe book icon (stack of book + chef hat)
// ─────────────────────────────────────────────────────────────────────────────
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
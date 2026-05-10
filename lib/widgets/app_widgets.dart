import 'package:flutter/material.dart';

/// App logo widget with fork, knife and spoon icons.
/// TODO: Replace with your actual Image.asset('assets/logo.png') or similar.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Fork
          Icon(Icons.fork_right, size: size * 0.28, color: const Color(0xFF1565C0)),
          SizedBox(width: size * 0.02),
          // Knife / utensil
          Icon(Icons.straighten, size: size * 0.28, color: const Color(0xFF00897B)),
          SizedBox(width: size * 0.02),
          // Spoon
          Icon(Icons.soup_kitchen, size: size * 0.28, color: const Color(0xFF7CB342)),
        ],
      ),
    );
  }
}

/// Image placeholder used throughout the app.
/// TODO: Replace with Image.network(url) or Image.asset(path) when data is available.
class RecipeImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const RecipeImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.restaurant, size: 48, color: Colors.grey),
      ),
    );

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}
import 'package:flutter/material.dart';

/// App logo widget.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.network(
          'https://raw.githubusercontent.com/AngelSPerez/PROYECTO-FINAL-FLUTTER/refs/heads/main/image.png',
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
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
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(Icons.restaurant, size: 48, color: Theme.of(context).colorScheme.outline),
      ),
    );

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}
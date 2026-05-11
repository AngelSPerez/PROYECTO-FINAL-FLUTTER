import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/app_widgets.dart';

class AdminRecipesScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminRecipesScreen({super.key, required this.recipes});

  @override
  State<AdminRecipesScreen> createState() => _AdminRecipesScreenState();
}

class _AdminRecipesScreenState extends State<AdminRecipesScreen> {
  late List<Recipe> _recipes;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _recipes = List.from(widget.recipes);
  }

  List<Recipe> get _filtered => _recipes
      .where((r) => r.title.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void _deleteRecipe(Recipe recipe) {
    setState(() => _recipes.remove(recipe));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${recipe.title}" eliminada')),
    );
  }

  String _nextId() =>
      (_recipes.map((r) => int.parse(r.id)).reduce((a, b) => a > b ? a : b) + 1)
          .toString();

  Future<void> _showRecipeForm({Recipe? existing}) async {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final prepCtrl = TextEditingController(text: existing?.prepTime ?? '');
    final cookCtrl = TextEditingController(text: existing?.cookTime ?? '');
    final totalCtrl = TextEditingController(text: existing?.totalTime ?? '');
    final ingCtrl = TextEditingController(
        text: existing?.ingredients.join(', ') ?? '');
    final stepsCtrl = TextEditingController(
        text: existing?.steps.join('\n') ?? '');
    final ratingCtrl = TextEditingController(
        text: existing?.rating.toString() ?? '4.0');

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing != null ? 'Editar receta' : 'Nueva receta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Título')),
              TextField(
                  controller: prepCtrl,
                  decoration: const InputDecoration(labelText: 'Prep time')),
              TextField(
                  controller: cookCtrl,
                  decoration: const InputDecoration(labelText: 'Cook time')),
              TextField(
                  controller: totalCtrl,
                  decoration: const InputDecoration(labelText: 'Total time')),
              TextField(
                  controller: ingCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Ingredientes (separados por coma)')),
              TextField(
                  controller: stepsCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Pasos (uno por línea)')),
              TextField(
                  controller: ratingCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Calificación')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Guardar')),
        ],
      ),
    );

    if (saved != true) return;
    if (titleCtrl.text.trim().isEmpty) return;

    setState(() {
      final recipe = Recipe(
        id: existing?.id ?? _nextId(),
        title: titleCtrl.text.trim(),
        prepTime: prepCtrl.text.trim(),
        cookTime: cookCtrl.text.trim(),
        totalTime: totalCtrl.text.trim(),
        ingredients: ingCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        steps: stepsCtrl.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        rating: double.tryParse(ratingCtrl.text) ?? 4.0,
      );

      if (existing != null) {
        final idx = _recipes.indexOf(existing);
        if (idx >= 0) _recipes[idx] = recipe;
      } else {
        _recipes.add(recipe);
      }
    });
  }

  void _showRecipeOptions(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(recipe.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar receta'),
              onTap: () {
                Navigator.pop(context);
                _showRecipeForm(existing: recipe);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Eliminar receta',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteRecipe(recipe);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('Recetas',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showRecipeForm(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Buscar receta...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                isDense: true,
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).colorScheme.outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? Center(
              child: Text('No recipes found',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final recipe = _filtered[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recipe.imageUrl != null
                        ? Image.network(
                            recipe.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : RecipeImagePlaceholder(
                            width: 56,
                            height: 56,
                            borderRadius: BorderRadius.circular(8),
                          ),
                  ),
                  title: Text(recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 13, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 3),
                      Text(recipe.totalTime,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star,
                          size: 13, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(recipe.rating.toString(),
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showRecipeOptions(recipe),
                  ),
                );
              },
            ),
    );
  }
}

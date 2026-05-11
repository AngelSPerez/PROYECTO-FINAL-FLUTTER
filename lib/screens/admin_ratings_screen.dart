import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AdminRatingsScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminRatingsScreen({super.key, required this.recipes});

  @override
  State<AdminRatingsScreen> createState() => _AdminRatingsScreenState();
}

class _AdminRatingsScreenState extends State<AdminRatingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _ratings = [
    {'user': 'Angel Salinas', 'stars': 4.5, 'recipeIdx': 0},
    {'user': 'María López', 'stars': 5.0, 'recipeIdx': 3},
    {'user': 'Carlos Ruiz', 'stars': 3.5, 'recipeIdx': 1},
  ];

  List<Map<String, dynamic>> get _filtered => _ratings.where((r) {
        final recipe = r['recipeIdx'] < widget.recipes.length
            ? widget.recipes[r['recipeIdx']]
            : null;
        final q = _query.toLowerCase();
        return r['user'].toLowerCase().contains(q) ||
            (recipe?.title.toLowerCase().contains(q) ?? false);
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteRating(int index) {
    setState(() => _ratings.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calificación eliminada')),
    );
  }

  String _starsText(double stars) {
    final full = stars.floor();
    final half = stars - full >= 0.25;
    final s = '★' * full + (half ? '½' : '');
    return '$s $stars';
  }

  Future<void> _showRatingForm({int? editIndex}) async {
    final realIdx = editIndex != null ? _ratings.indexOf(_filtered[editIndex]) : null;
    final existing = realIdx != null ? _ratings[realIdx] : null;
    String selectedUser = existing?['user'] ?? 'Angel Salinas';
    int selectedRecipe = existing?['recipeIdx'] ?? 0;
    double stars = existing?['stars'] ?? 3.0;
    final users = ['Angel Salinas', 'María López', 'Carlos Ruiz'];

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(
              editIndex != null ? 'Editar calificación' : 'Nueva calificación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                items: users
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setDlg(() => selectedUser = v!),
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedRecipe,
                items: widget.recipes.asMap().entries.map((e) {
                  return DropdownMenuItem(
                      value: e.key, child: Text(e.value.title));
                }).toList(),
                onChanged: (v) => setDlg(() => selectedRecipe = v!),
                decoration: const InputDecoration(labelText: 'Receta'),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 28,
                    ),
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                    onPressed: () =>
                        setDlg(() => stars = (i + 1).toDouble()),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Guardar')),
          ],
        ),
      ),
    );

    if (saved != true) return;

    setState(() {
      final entry = {
        'user': selectedUser,
        'stars': stars,
        'recipeIdx': selectedRecipe,
      };
      if (realIdx != null) {
        _ratings[realIdx] = entry;
      } else {
        _ratings.insert(0, entry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('Calificaciones',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showRatingForm(),
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
                hintText: 'Buscar por usuario o receta...',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('No ratings yet',
                      style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = _filtered[index];
                final recipe = entry['recipeIdx'] < widget.recipes.length
                    ? widget.recipes[entry['recipeIdx']]
                    : null;

                return Dismissible(
                  key: Key('rating_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                    onDismissed: (_) => _deleteRating(
                        _ratings.indexOf(entry)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.person,
                                  size: 18, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(entry['user'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _showRatingForm(editIndex: index),
                              child: Icon(Icons.edit,
                                  size: 18, color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _deleteRating(
                                  _ratings.indexOf(entry)),
                              child: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.redAccent),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _starsText(entry['stars']),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (recipe != null)
                          Text(recipe.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF9C27B0),
                              )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

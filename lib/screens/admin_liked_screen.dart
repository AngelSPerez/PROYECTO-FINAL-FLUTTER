import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AdminLikedScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminLikedScreen({super.key, required this.recipes});

  @override
  State<AdminLikedScreen> createState() => _AdminLikedScreenState();
}

class _AdminLikedScreenState extends State<AdminLikedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _entries = [
    {'user': 'Angel Salinas', 'recipeIdx': 1},
    {'user': 'María López', 'recipeIdx': 3},
    {'user': 'Carlos Ruiz', 'recipeIdx': 0},
    {'user': 'Angel Salinas', 'recipeIdx': 3},
  ];

  final _availableUsers = ['Angel Salinas', 'María López', 'Carlos Ruiz'];

  List<Map<String, dynamic>> get _filtered => _entries.where((e) {
        final recipe = e['recipeIdx'] < widget.recipes.length
            ? widget.recipes[e['recipeIdx']]
            : null;
        final title = recipe?.title.toLowerCase() ?? '';
        final user = (e['user'] as String).toLowerCase();
        final q = _query.toLowerCase();
        return title.contains(q) || user.contains(q);
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteEntry(Map<String, dynamic> entry) {
    setState(() => _entries.remove(entry));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entrada eliminada')),
    );
  }

  void _showEntryOptions(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Opciones',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar entrada'),
              onTap: () {
                Navigator.pop(context);
                _showEntryForm(existing: entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Eliminar entrada',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteEntry(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEntryForm({Map<String, dynamic>? existing}) async {
    String selectedUser = existing?['user'] ?? _availableUsers[0];
    int selectedRecipe = existing?['recipeIdx'] ?? 0;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(existing != null ? 'Editar entrada' : 'Agregar gustado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                items: _availableUsers
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

    if (result != true) return;
    setState(() {
      final entry = {
        'user': selectedUser,
        'recipeIdx': selectedRecipe,
      };
      if (existing != null) {
        final idx = _entries.indexOf(existing);
        if (idx >= 0) _entries[idx] = entry;
      } else {
        _entries.insert(0, entry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('Gustados',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showEntryForm(),
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
              child: Text('No hay entradas',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final entry = _filtered[i];
                final recipe = entry['recipeIdx'] < widget.recipes.length
                    ? widget.recipes[entry['recipeIdx']]
                    : null;
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.favorite,
                        color: Colors.white, size: 18),
                  ),
                  title: Text(recipe?.title ?? '???',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(entry['user'],
                      style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showEntryOptions(entry),
                  ),
                );
              },
            ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firebase_service.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminLikedScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminLikedScreen({super.key, required this.recipes});

  @override
  State<AdminLikedScreen> createState() => _AdminLikedScreenState();
}

class _AdminLikedScreenState extends State<AdminLikedScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<Map<String, dynamic>> _entries = [];
  StreamSubscription? _subscription;

  final _availableUsers = ['Angel Salinas', 'María López', 'Carlos Ruiz'];

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseService.instance.streamLiked().listen((entries) {
      if (mounted) setState(() => _entries = entries);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered => _entries.where((e) {
        final recipeIdx = e['recipeIdx'] as int? ?? -1;
        final recipe = recipeIdx >= 0 && recipeIdx < widget.recipes.length
            ? widget.recipes[recipeIdx]
            : null;
        final title = recipe?.title.toLowerCase() ?? '';
        final user = (e['user'] as String? ?? '').toLowerCase();
        final q = _query.toLowerCase();
        return title.contains(q) || user.contains(q);
      }).toList();

  Future<void> _deleteEntry(String docId) async {
    await FirebaseService.instance.deleteLiked(docId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.entryDeleted)),
    );
  }

  void _showEntryOptions(Map<String, dynamic> entry) {
    final docId = entry['id'] as String? ?? '';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Str.options, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(Str.deleteEntry, style: const TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteEntry(docId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEntryForm() async {
    String selectedUser = _availableUsers[0];
    int selectedRecipe = 0;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(Str.newLikedEntry),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                items: _availableUsers.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (v) => setDlg(() => selectedUser = v!),
                decoration: InputDecoration(labelText: Str.user),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedRecipe,
                items: widget.recipes.asMap().entries.map((e) {
                  return DropdownMenuItem(value: e.key, child: Text(e.value.title));
                }).toList(),
                onChanged: (v) => setDlg(() => selectedRecipe = v!),
                decoration: InputDecoration(labelText: Str.recipe),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(Str.cancel)),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(Str.save)),
          ],
        ),
      ),
    );

    if (result != true) return;
    await FirebaseService.instance.addLiked({
      'user': selectedUser,
      'recipeIdx': selectedRecipe,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.liked, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showEntryForm,
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
                hintText: Str.searchUserOrRecipe,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                isDense: true,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.outline, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? Center(
              child: Text(Str.noEntries,
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final entry = _filtered[i];
                final recipeIdx = entry['recipeIdx'] as int? ?? -1;
                final recipe = recipeIdx >= 0 && recipeIdx < widget.recipes.length
                    ? widget.recipes[recipeIdx]
                    : null;
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.favorite, color: Colors.white, size: 18),
                  ),
                  title: Text(recipe?.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${entry['user'] ?? ''}', style: const TextStyle(fontSize: 12)),
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

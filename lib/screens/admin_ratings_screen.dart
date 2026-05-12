import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firebase_service.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminRatingsScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminRatingsScreen({super.key, required this.recipes});

  @override
  State<AdminRatingsScreen> createState() => _AdminRatingsScreenState();
}

class _AdminRatingsScreenState extends State<AdminRatingsScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<Map<String, dynamic>> _ratings = [];
  StreamSubscription? _subscription;

  final _users = ['Angel Salinas', 'María López', 'Carlos Ruiz'];

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseService.instance.streamRatings().listen((ratings) {
      if (mounted) setState(() => _ratings = ratings);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered => _ratings.where((r) {
        final recipeIdx = r['recipeIdx'] as int? ?? -1;
        final recipe = recipeIdx >= 0 && recipeIdx < widget.recipes.length
            ? widget.recipes[recipeIdx]
            : null;
        final q = _query.toLowerCase();
        return (r['user'] as String? ?? '').toLowerCase().contains(q) ||
            (recipe?.title.toLowerCase().contains(q) ?? false);
      }).toList();

  Future<void> _deleteRating(String docId) async {
    await FirebaseService.instance.deleteRating(docId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.ratingDeleted)),
    );
  }

  String _starsText(double stars) {
    final full = stars.floor();
    final half = stars - full >= 0.25;
    final s = '★' * full + (half ? '½' : '');
    return '$s $stars';
  }

  Future<void> _showRatingForm({String? editDocId}) async {
    final existing = editDocId != null
        ? _ratings.firstWhere((r) => r['id'] == editDocId, orElse: () => <String, dynamic>{})
        : null;
    String selectedUser = existing?['user'] ?? _users[0];
    int selectedRecipe = existing?['recipeIdx'] ?? 0;
    double stars = (existing?['stars'] as num?)?.toDouble() ?? 3.0;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(editDocId != null ? Str.editRating : Str.newRating),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                items: _users.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
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
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(i < stars ? Icons.star : Icons.star_border, color: Colors.amber, size: 28),
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    onPressed: () => setDlg(() => stars = (i + 1).toDouble()),
                  );
                }),
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

    if (saved != true) return;

    final data = {
      'user': selectedUser,
      'stars': stars,
      'recipeIdx': selectedRecipe,
    };

    if (editDocId != null) {
      await FirebaseService.instance.updateRating(editDocId, data);
    } else {
      await FirebaseService.instance.addRating(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.ratings,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(Str.noRatingsYet,
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
                final recipeIdx = entry['recipeIdx'] as int? ?? -1;
                final recipe = recipeIdx >= 0 && recipeIdx < widget.recipes.length
                    ? widget.recipes[recipeIdx]
                    : null;
                final docId = entry['id'] as String? ?? '';

                return Dismissible(
                  key: Key('rating_$docId'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteRating(docId),
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
                              child: Icon(Icons.person, size: 18, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(entry['user'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () => _showRatingForm(editDocId: docId),
                              child: Icon(Icons.edit, size: 18, color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _deleteRating(docId),
                              child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _starsText((entry['stars'] as num?)?.toDouble() ?? 0),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (recipe != null)
                          Text(recipe.title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF9C27B0))),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminCommentsScreen extends StatefulWidget {
  const AdminCommentsScreen({super.key});

  @override
  State<AdminCommentsScreen> createState() => _AdminCommentsScreenState();
}

class _AdminCommentsScreenState extends State<AdminCommentsScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _comments = [
    {
      'user': 'Angel Salinas',
      'avatar': null,
      'time': '1h',
      'text':
          'Preparé este pay de manzana y quedó muy bien, con masa crujiente y relleno suave.',
      'recipe': 'Apple Pie',
    },
    {
      'user': 'María López',
      'avatar': null,
      'time': '3h',
      'text':
          'Las galletas quedaron perfectas, muy esponjosas por dentro y crocantes por fuera.',
      'recipe': 'Cookies',
    },
    {
      'user': 'Carlos Ruiz',
      'avatar': null,
      'time': '1d',
      'text':
          'El pollo me quedó un poco seco, pero el sabor era buenísimo. La próxima vez lo dejo menos tiempo.',
      'recipe': 'Chicken',
    },
  ];

  final _availableRecipes = ['Apple Pie', 'Chicken', 'Cheesecake', 'Cookies', 'Wings', 'Pasta', 'Tacos', 'Pancakes'];
  final _availableUsers = ['Angel Salinas', 'María López', 'Carlos Ruiz'];

  List<Map<String, dynamic>> get _filtered => _comments.where((c) {
        final q = _query.toLowerCase();
        return c['user'].toLowerCase().contains(q) ||
            c['recipe'].toLowerCase().contains(q) ||
            c['text'].toLowerCase().contains(q);
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteComment(int index) {
    setState(() => _comments.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.commentDeleted)),
    );
  }

  Future<void> _showCommentForm({int? editIndex}) async {
    final realIdx = editIndex != null ? _comments.indexOf(_filtered[editIndex]) : null;
    final existing = realIdx != null ? _comments[realIdx] : null;
    final textCtrl = TextEditingController(text: existing?['text'] ?? '');
    String selectedUser = existing?['user'] ?? _availableUsers[0];
    String selectedRecipe = existing?['recipe'] ?? _availableRecipes[0];

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(editIndex != null ? Str.editComment : Str.newComment),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                items: _availableUsers
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setDlg(() => selectedUser = v!),
                decoration: InputDecoration(labelText: Str.user),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedRecipe,
                items: _availableRecipes
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setDlg(() => selectedRecipe = v!),
                decoration: InputDecoration(labelText: Str.recipe),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: Str.comment, border: const OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(Str.cancel)),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(Str.save)),
          ],
        ),
      ),
    );

    if (saved != true || textCtrl.text.trim().isEmpty) return;

    setState(() {
      final entry = {
        'user': selectedUser,
        'time': editIndex != null ? existing!['time'] : 'Just now',
        'text': textCtrl.text.trim(),
        'recipe': selectedRecipe,
      };
      if (realIdx != null) {
        _comments[realIdx] = entry;
      } else {
        _comments.insert(0, entry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.comments,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCommentForm(),
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
                hintText: Str.searchComment,
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
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(Str.noCommentsYet,
                      style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final c = _filtered[index];
                return Dismissible(
                  key: Key('comment_$index'),
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
                  onDismissed: (_) => _deleteComment(index),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
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
                              child: Text(c['user'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () => _showCommentForm(editIndex: index),
                              child: Icon(Icons.edit,
                                  size: 18, color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _deleteComment(index),
                              child: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.redAccent),
                            ),
                            const SizedBox(width: 8),
                            Text(c['time'],
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(c['text'],
                            style:
                                const TextStyle(fontSize: 13, height: 1.4)),
                        const SizedBox(height: 6),
                        Text(c['recipe'],
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

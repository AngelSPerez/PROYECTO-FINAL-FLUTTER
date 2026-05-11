import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Angel Salinas',
      'email': 'angel@gmail.com',
      'role': 'user',
      'joined': 'Jan 2024',
      'saved': 3,
      'liked': 2,
    },
    {
      'name': 'María López',
      'email': 'maria@gmail.com',
      'role': 'user',
      'joined': 'Mar 2024',
      'saved': 5,
      'liked': 4,
    },
    {
      'name': 'Carlos Ruiz',
      'email': 'carlos@gmail.com',
      'role': 'admin',
      'joined': 'Dec 2023',
      'saved': 1,
      'liked': 0,
    },
  ];

  String _query = '';

  List<Map<String, dynamic>> get _filtered => _users
      .where((u) =>
          u['name'].toLowerCase().contains(_query.toLowerCase()) ||
          u['email'].toLowerCase().contains(_query.toLowerCase()))
      .toList();

  Future<void> _showUserForm({Map<String, dynamic>? existing}) async {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final emailCtrl = TextEditingController(text: existing?['email'] ?? '');
    String role = existing?['role'] ?? 'user';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(existing != null ? Str.editUser : Str.newUser),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: Str.name)),
              TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: Str.email)),
              DropdownButtonFormField<String>(
                initialValue: role,
                items: [
                  DropdownMenuItem(value: 'user', child: Text(Str.user)),
                  DropdownMenuItem(value: 'admin', child: Text(Str.admin)),
                ],
                onChanged: (v) => setDlg(() => role = v ?? 'user'),
                decoration: InputDecoration(labelText: Str.role),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(Str.cancel)),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, {
                  'name': nameCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'role': role,
                }),
                child: Text(Str.save)),
          ],
        ),
      ),
    );

    if (result == null || result['name']!.isEmpty) return;

    setState(() {
      if (existing != null) {
        existing['name'] = result['name'];
        existing['email'] = result['email'];
        existing['role'] = result['role'];
      } else {
        _users.add({
          'name': result['name'],
          'email': result['email'],
          'role': result['role'],
          'joined': 'Just now',
          'saved': 0,
          'liked': 0,
        });
      }
    });
  }

  void _deleteUser(Map<String, dynamic> user) {
    setState(() => _users.remove(user));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.deletedUser(user['name']))),
    );
  }

  void _showUserOptions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user['name'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(Str.editUser),
              onTap: () {
                Navigator.pop(context);
                _showUserForm(existing: user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text(user['role'] == 'admin'
                  ? Str.removeAdmin
                  : Str.makeAdmin),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  user['role'] = user['role'] == 'admin' ? 'user' : 'admin';
                });
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(Str.deleteUser,
                  style: const TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteUser(user);
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
        title: Text(Str.users,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () => _showUserForm(),
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
                hintText: Str.searchUser,
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
              child: Text(Str.noUsersFound,
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final user = _filtered[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF9C27B0),
                    child: Text(
                      (user['name'] as String)[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(user['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (user['role'] == 'admin') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C27B0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(Str.admin,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(user['email'],
                      style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border,
                          size: 16, color: Theme.of(context).colorScheme.outline),
                      Text(' ${user['saved']}  ',
                          style: const TextStyle(fontSize: 12)),
                      Icon(Icons.favorite_border,
                          size: 16, color: Theme.of(context).colorScheme.outline),
                      Text(' ${user['liked']}',
                          style: const TextStyle(fontSize: 12)),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () => _showUserOptions(user),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

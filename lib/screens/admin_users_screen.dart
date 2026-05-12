import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> with LocaleAwareState {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  String _query = '';
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseService.instance.streamUsers().listen((users) {
      if (mounted) setState(() => _users = users);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered => _users
      .where((u) =>
          (u['name'] as String? ?? '').toLowerCase().contains(_query.toLowerCase()) ||
          (u['email'] as String? ?? '').toLowerCase().contains(_query.toLowerCase()))
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
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: Str.name)),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: Str.email)),
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(Str.cancel)),
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

    if (existing != null) {
      await FirebaseService.instance.updateUser(existing['uid'] ?? existing['id'], result);
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final uid = user['uid'] ?? user['id'];
    if (uid == null) return;
    await FirebaseService.instance.deleteUser(uid);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.deletedUser(user['name']))),
    );
  }

  void _showUserOptions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              title: Text(user['role'] == 'admin' ? Str.removeAdmin : Str.makeAdmin),
              onTap: () {
                Navigator.pop(context);
                final uid = user['uid'] ?? user['id'];
                final newRole = user['role'] == 'admin' ? 'user' : 'admin';
                FirebaseService.instance.updateUser(uid, {'role': newRole});
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(Str.deleteUser, style: const TextStyle(color: Colors.redAccent)),
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.outline, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
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
                      ((user['name'] as String?) ?? '?')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(user['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (user['role'] == 'admin') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C27B0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(Str.admin,
                              style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(user['email'] ?? '', style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showUserOptions(user),
                  ),
                );
              },
            ),
    );
  }
}

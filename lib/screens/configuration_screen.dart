import 'package:flutter/material.dart';
import '../main.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  String _language = 'English';
  String _theme = AppTheme.mode.value == ThemeMode.dark ? 'Dark'
      : AppTheme.mode.value == ThemeMode.system ? 'System'
      : 'Light';
  final String _appName = 'ReciveRecipe';

  // TODO: Pull from FirebaseAuth.instance.currentUser
  final String _currentEmail = 'angel@gmail.com';

  // ── Language dialog ────────────────────────────────────────────────────────
  void _showLanguageDialog() {
    String selected = _language;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Language'),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setDlg(() => selected = v!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['English', 'Spanish'].map((lang) {
                return RadioListTile<String>(
                  value: lang,
                  title: Text(lang),
                  activeColor: Theme.of(context).colorScheme.primary,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _language = selected);
                Navigator.pop(ctx);
              },
              child: Text('Accept', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Theme dialog ───────────────────────────────────────────────────────────
  void _showThemeDialog() {
    String selected = _theme;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Theme'),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setDlg(() => selected = v!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Light', 'Dark', 'System'].map((t) {
                return RadioListTile<String>(
                  value: t,
                  title: Text(t),
                  activeColor: Theme.of(context).colorScheme.primary,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _theme = selected);
                AppTheme.mode.value = selected == 'Dark'
                    ? ThemeMode.dark
                    : selected == 'Light'
                        ? ThemeMode.light
                        : ThemeMode.system;
                Navigator.pop(ctx);
              },
              child: Text('Accept', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Change password dialog ─────────────────────────────────────────────────
  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PassField(controller: currentCtrl, label: 'Current password'),
            const SizedBox(height: 8),
            _PassField(controller: newCtrl, label: 'New password'),
            const SizedBox(height: 8),
            _PassField(controller: confirmCtrl, label: 'Confirm password'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: FirebaseAuth password update
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated')),
              );
            },
            child: const Text('Save',
                style: TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
    );
  }

  // ── Change email dialog ────────────────────────────────────────────────────
  void _showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: _currentEmail);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change E-mail'),
        content: TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'New e-mail',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: FirebaseAuth email update
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-mail updated')),
              );
            },
            child: const Text('Save',
                style: TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
    );
  }

  // ── About us dialog ────────────────────────────────────────────────────────
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About us'),
        content: const Text(
          'ReciveRecipe is a digital recipe book for home cooking enthusiasts. '
          'Discover, save, and share your favourite recipes.\n\nVersion 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text(
          'Configuration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _SettingsTile(
            title: 'Language',
            subtitle: _language,
            onTap: _showLanguageDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: 'Theme',
            subtitle: _theme,
            onTap: _showThemeDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: 'About us',
            subtitle: _appName,
            onTap: _showAboutDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: 'Change password',
            subtitle: '•••••••',
            onTap: _showChangePasswordDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: 'Change E-mail',
            subtitle: _currentEmail,
            onTap: _showChangeEmailDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}

// ── Reusable settings list tile ──────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }
}

// ── Password text field helper ────────────────────────────────────────────────
class _PassField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const _PassField({required this.controller, required this.label});

  @override
  State<_PassField> createState() => _PassFieldState();
}

class _PassFieldState extends State<_PassField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
              size: 20),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}
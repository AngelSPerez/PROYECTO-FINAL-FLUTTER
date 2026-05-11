import 'package:flutter/material.dart';
import '../main.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> with LocaleAwareState {
  String get _language => AppLocale.language.value == 'es' ? Str.spanish : Str.english;

  // ── Placeholder user data ───────────────────────────────────────────
  // TODO: Pull from FirebaseAuth.instance.currentUser
  final String _currentEmail = 'angel@gmail.com';

  String get _themeValue {
    switch (AppTheme.mode.value) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
      default:
        return 'Light';
    }
  }

  String get _themeLabel {
    switch (AppTheme.mode.value) {
      case ThemeMode.dark:
        return Str.dark;
      case ThemeMode.system:
        return Str.system;
      default:
        return Str.light;
    }
  }

  // ── Language dialog ────────────────────────────────────────────────────────
  void _showLanguageDialog() {
    String selected = AppLocale.language.value;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Str.language),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setDlg(() => selected = v!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['en', 'es'].map((lang) {
                return ListTile(
                  leading: Radio<String>(value: lang),
                  title: Text(lang == 'en' ? Str.english : Str.spanish),
                  onTap: () => setDlg(() => selected = lang),
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppLocale.language.value = selected;
                Navigator.pop(ctx);
              },
              child: Text(Str.accept, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Theme dialog ───────────────────────────────────────────────────────────
  void _showThemeDialog() {
    String selected = _themeValue;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Str.theme),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setDlg(() => selected = v!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Light', 'Dark', 'System'].map((t) {
                return ListTile(
                  leading: Radio<String>(value: t),
                  title: Text(t == 'Light' ? Str.light : t == 'Dark' ? Str.dark : Str.system),
                  onTap: () => setDlg(() => selected = t),
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppTheme.mode.value = selected == 'Dark'
                    ? ThemeMode.dark
                    : selected == 'Light'
                        ? ThemeMode.light
                        : ThemeMode.system;
                Navigator.pop(ctx);
              },
              child: Text(Str.accept, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Change password dialog (placeholder) ──────────────────────────────────
  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(Str.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PassField(controller: currentCtrl, label: Str.currentPassword),
            const SizedBox(height: 8),
            _PassField(controller: newCtrl, label: Str.newPassword),
            const SizedBox(height: 8),
            _PassField(controller: confirmCtrl, label: Str.confirmPassword),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Str.cancel),
          ),
          TextButton(
            onPressed: () {
              // TODO: FirebaseAuth password update
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(Str.passwordUpdated)),
              );
            },
            child: Text(Str.save,
                style: const TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
    );
  }

  // ── Change email dialog (placeholder) ──────────────────────────────────────
  void _showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: _currentEmail);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(Str.changeEmail),
        content: TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: Str.newEmail,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Str.cancel),
          ),
          TextButton(
            onPressed: () {
              // TODO: FirebaseAuth email update
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(Str.emailUpdated)),
              );
            },
            child: Text(Str.save,
                style: const TextStyle(color: Color(0xFF9C27B0))),
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
        title: Text(Str.aboutUs),
        content: Text(Str.aboutText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Str.close),
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
        title: Text(
          Str.configurationTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _SettingsTile(
            title: Str.language,
            subtitle: _language,
            onTap: _showLanguageDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: Str.theme,
            subtitle: _themeLabel,
            onTap: _showThemeDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: Str.aboutUs,
            subtitle: 'ReciveRecipe',
            onTap: _showAboutDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: Str.changePassword,
            subtitle: '•••••••',
            onTap: _showChangePasswordDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _SettingsTile(
            title: Str.changeEmail,
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

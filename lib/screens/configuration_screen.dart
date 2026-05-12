import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> with LocaleAwareState {
  String get _language {
    switch (AppLocale.language.value) {
      case 'es':
        return Str.spanish;
      case 'pt_BR':
        return Str.portuguese;
      default:
        return Str.english;
    }
  }

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

  String get _currentEmail => AuthService.instance.currentUser?.email ?? '';

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
              children: ['en', 'es', 'pt_BR'].map((lang) {
                return ListTile(
                  leading: Radio<String>(value: lang),
                  title: Text(lang == 'en'
                      ? Str.english
                      : lang == 'es'
                          ? Str.spanish
                          : Str.portuguese),
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
            onPressed: () async {
              if (newCtrl.text != confirmCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              try {
                await AuthService.instance.changePassword(
                  currentCtrl.text,
                  newCtrl.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(Str.passwordUpdated)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: Text(Str.save,
                style: const TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: _currentEmail);
    final passwordCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(Str.changeEmail),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: Str.newEmail,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: Str.currentPassword,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Str.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (passwordCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password required')),
                );
                return;
              }
              try {
                await AuthService.instance.changeEmail(
                  emailCtrl.text.trim(),
                  passwordCtrl.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(Str.emailUpdated)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: Text(Str.save,
                style: const TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
    );
  }

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
      body: SafeArea(
        child: Column(
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
      ),
    );
  }
}

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

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import 'splash_screen.dart';
import 'configuration_screen.dart';
import 'user_items_screen.dart';
import 'admin_panel_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.language,
      builder: (_, __, ___) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

                Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.5,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 70,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  user?.name ?? 'User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (user != null)
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
            const SizedBox(height: 4),
            const Divider(),

            _ProfileItem(
              icon: Icons.bookmark_border,
              label: Str.saved,
              onTap: () async {
                final recipes = await FirebaseService.instance.getRecipes();
                if (!context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserSavedScreen(recipes: recipes)));
              },
            ),
            _ProfileItem(
              icon: Icons.favorite,
              iconColor: Colors.red,
              label: Str.liked,
              onTap: () async {
                final recipes = await FirebaseService.instance.getRecipes();
                if (!context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserLikedScreen(recipes: recipes)));
              },
            ),
            _ProfileItem(
              icon: Icons.chat_bubble_outline,
              label: Str.commented,
              onTap: () async {
                final recipes = await FirebaseService.instance.getRecipes();
                if (!context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserCommentsScreen(recipes: recipes)));
              },
            ),
            _ProfileItem(
              icon: Icons.star,
              iconColor: Colors.amber,
              label: Str.rates,
              onTap: () async {
                final recipes = await FirebaseService.instance.getRecipes();
                if (!context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserRatingsScreen(recipes: recipes)));
              },
            ),
            _ProfileItem(
              icon: Icons.settings_outlined,
              label: Str.configuration,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfigurationScreen(),
                ),
              ),
            ),
            if (user?.role == 'admin')
              _ProfileItem(
                icon: Icons.admin_panel_settings_outlined,
                label: Str.adminPanel,
                onTap: () async {
                  final recipes = await FirebaseService.instance.getRecipes();
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminPanelScreen(recipes: recipes),
                    ),
                  );
                },
              ),
            const Divider(),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _confirmLogout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    Str.logOut,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Str.logOutConfirmTitle),
        content: Text(Str.logOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(Str.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.instance.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            child:
                Text(Str.logOutShort, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.onSurface, size: 24),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.26)),
      onTap: onTap,
    );
  }
}

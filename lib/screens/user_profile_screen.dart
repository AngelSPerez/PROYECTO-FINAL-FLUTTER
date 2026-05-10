import 'package:flutter/material.dart';
import 'splash_screen.dart';

/// User profile screen.
/// TODO: Load real user data from Firebase Auth / Firestore.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  // TODO: Replace with actual logged-in user name from Firebase Auth.
  static const String _userName = 'Angel Salinas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Avatar
            Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2.5),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 70,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            // Name — TODO: replace with Firebase Auth displayName
            const Text(
              _userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Divider(),

            // Menu items
            _ProfileItem(
              icon: Icons.bookmark_border,
              label: 'Saved',
              onTap: () {
                // TODO: Navigate to saved recipes screen
              },
            ),
            _ProfileItem(
              icon: Icons.favorite,
              iconColor: Colors.red,
              label: 'Liked',
              onTap: () {
                // TODO: Navigate to liked recipes screen
              },
            ),
            _ProfileItem(
              icon: Icons.chat_bubble_outline,
              label: 'Commented',
              onTap: () {
                // TODO: Navigate to comments screen
              },
            ),
            _ProfileItem(
              icon: Icons.star,
              iconColor: Colors.amber,
              label: 'Rates',
              onTap: () {
                // TODO: Navigate to rated recipes screen
              },
            ),
            _ProfileItem(
              icon: Icons.settings_outlined,
              label: 'Configuration',
              onTap: () {
                // TODO: Navigate to settings screen
              },
            ),
            const Divider(),

            const Spacer(),

            // Log out
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
                  child: const Text(
                    'Log out',
                    style: TextStyle(
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
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (_) => false,
              );
            },
            child:
                const Text('Log out', style: TextStyle(color: Colors.red)),
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
      leading: Icon(icon, color: iconColor ?? Colors.black87, size: 24),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black26),
      onTap: onTap,
    );
  }
}
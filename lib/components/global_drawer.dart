import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polaris/service/theme_service.dart';

class GlobalDrawer extends StatefulWidget {
  const GlobalDrawer({super.key});

  @override
  State<GlobalDrawer> createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {
  bool _isFeatureEnabled = false;

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'User';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            accountName: const Text('Polaris Recall'),
            accountEmail: Text(userEmail),
            decoration: BoxDecoration(color: Colors.blueGrey.shade900),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Exams'),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/exams');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Subjects'),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/subjects');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Modules'),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/modules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Topics'),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/topics');
            },
          ),
          const Spacer(),
          const Divider(),

          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: Icon(
              themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: themeService.isDarkMode ? Colors.amber : Colors.blueGrey,
            ),
            // 1. Read the current value from the global service
            value: themeService.isDarkMode,
            onChanged: (bool value) {
              // 2. Update the global service
              setState(() {
                themeService.toggleTheme(value);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

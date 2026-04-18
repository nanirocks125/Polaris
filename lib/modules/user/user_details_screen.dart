import 'package:flutter/material.dart';
import 'package:polaris/provider/app_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<AppUserProvider>();
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      user.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name ?? 'Anonymous User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(user.role.name.toUpperCase()),
                    backgroundColor: user.isAdmin
                        ? Colors.amber.shade100
                        : Colors.blue.shade50,
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            // App State Section
            _buildSectionHeader(context, 'Current Focus'),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in_outlined),
              title: const Text('Active Exam ID'),
              subtitle: Text(
                user.activeExam?.title ?? 'No active exam selected',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                /* Navigate to Exam Switcher */
              },
            ),
            // Settings Section
            _buildSectionHeader(context, 'Settings'),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: user.settings.isDarkMode,
                onChanged: (val) {
                  // Update logic via UserService
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('Preferred Language'),
              subtitle: Text(
                user.settings.preferredLanguage == 'te' ? 'Telugu' : 'English',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

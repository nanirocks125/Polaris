import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/provider/app_user_provider.dart';
import 'package:provider/provider.dart';

class ScaffoldGlobalDrawer extends StatelessWidget {
  final Widget child;
  final String title;

  const ScaffoldGlobalDrawer({
    super.key,
    required this.child,
    this.title = 'Polaris',
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<AppUserProvider>();
    final user = userProvider.user; // Get the user object
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: user == null
            ? const Center(
                child: CircularProgressIndicator(),
              ) // 1. Show loader if data is fetching
            : Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    accountName: Text('Polaris Recall'),
                    accountEmail: Text(user.email ?? ''),
                    decoration: BoxDecoration(color: Colors.blueGrey.shade900),
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: const Text('Dashboard'),
                    onTap: () {
                      context.pop(); // Close drawer
                      context.go('/');
                    },
                  ),

                  if (user.isAdmin) ...[
                    ListTile(
                      leading: const Icon(Icons.assignment_outlined),
                      title: const Text('Users'),
                      onTap: () {
                        context.pop(); // Close drawer
                        context.go('/users');
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
                  ],

                  const Spacer(),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('My Profile'),
                    onTap: () {
                      context.pop(); // Close drawer first
                      context.push('/profile');
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
      ), // Your global drawer
      body: child, // This is where the specific page content is injected
    );
  }
}

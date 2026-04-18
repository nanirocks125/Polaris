import 'package:flutter/material.dart';
import 'package:polaris/modules/exam/exam_snapshot.dart';
import 'package:polaris/modules/user/app_user_service.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.assignment_turned_in_outlined,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Active Exam'),
                    subtitle: user.assignedExams.isEmpty
                        ? const Text('No exams assigned yet')
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<ExamSnapshot>(
                              isExpanded: true,
                              value: user.activeExam,
                              hint: const Text('Select an Exam'),
                              // 1. Generate items from assigned snapshots
                              items: user.assignedExams.map((snapshot) {
                                return DropdownMenuItem<ExamSnapshot>(
                                  value: snapshot,
                                  child: Text(snapshot.title),
                                );
                              }).toList(),
                              // 2. Switch logic
                              onChanged: (ExamSnapshot? selectedExam) async {
                                if (selectedExam != null) {
                                  await AppUserService(
                                    uid: user.id,
                                  ).switchActiveExam(selectedExam);
                                  // Provider will automatically notify and update the UI
                                }
                              },
                            ),
                          ),
                  ),
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';
import 'package:polaris/modules/user/app_user.dart';
import 'package:polaris/modules/user/app_user_service.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: StreamBuilder<List<AppUser>>(
        stream: AppUserService(uid: '').getAllUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                  ), // ఇది మీకు అసలు కారణం చెప్తుంది
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.name ?? 'Unknown'),
                  subtitle: Text('${user.assignedExams.length} Exams Assigned'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_task, color: Colors.blue),
                    onPressed: () => _showAssignDialog(context, user),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAssignDialog(BuildContext context, AppUser user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ExamPickerSheet(user: user),
    );
  }
}

class ExamPickerSheet extends StatelessWidget {
  final AppUser user;
  const ExamPickerSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign Exam to ${user.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Divider(),
          Flexible(
            child: StreamBuilder<List<Exam>>(
              stream: ExamService().getExamsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final availableExams = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableExams.length,
                  itemBuilder: (context, index) {
                    final exam = availableExams[index];

                    // 1. Check if the exam is already assigned to this user
                    final bool isAlreadyAssigned = user.assignedExams.any(
                      (snapshot) => snapshot.id == exam.id,
                    );

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        exam.title,
                        style: TextStyle(
                          color: isAlreadyAssigned ? Colors.grey : Colors.white,
                          fontWeight: isAlreadyAssigned
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      // 2. Visual Indicator
                      trailing: isAlreadyAssigned
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(
                              Icons.add_circle_outline,
                              color: Colors.blue,
                            ),

                      // 3. Disable tap if already assigned (Optional)
                      onTap: isAlreadyAssigned
                          ? null
                          : () async {
                              await AppUserService(
                                uid: '',
                              ).assignExamToUser(user.id, exam);
                              if (context.mounted) Navigator.pop(context);
                            },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

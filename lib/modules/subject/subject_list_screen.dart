import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/subject/subject.dart';
import 'package:polaris/modules/subject/subject_service.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectService = SubjectService();

    return Scaffold(
      appBar: AppBar(title: const Text('Subject Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, subjectService),
        label: const Text('New Subject'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Subject>>(
        stream: subjectService.getSubjectsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final subjects = snapshot.data ?? [];
          if (subjects.isEmpty)
            return const Center(child: Text('No subjects added yet.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.book_outlined)),
                  title: Text(
                    subject.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subject.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/subject-details', extra: subject),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, SubjectService service) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Create Subject'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Subject Title (e.g. Polity)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await service.createSubject(
                  Subject(title: titleController.text.trim()),
                );
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/subject/model/subject.dart';
import 'package:polaris/modules/subject/subject_service.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final Subject subject;
  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/edit-subject', extra: subject),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  subject.isGeneralStudies ? 'General Studies' : 'Optional',
                ),
                backgroundColor: Colors.blueGrey.withOpacity(0.2),
              ),
              const SizedBox(height: 24),
              const Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subject.description.isEmpty
                    ? 'No description provided.'
                    : subject.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),

              // --- THE NEW MODULE LIST CALL ---
              _buildModuleList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subject?'),
        content: const Text(
          'This will remove this subject from the library. Exams referencing this subject may be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await SubjectService().deleteSubject(subject.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                context.pop(); // Back to list
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Inside SubjectDetailsScreen build method
  Widget _buildModuleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CURRICULUM MODULES",
          style: TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        ...subject.modules.map(
          (module) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: const CircleAvatar(child: Icon(Icons.folder_open)),
              title: Text(
                module.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Tap to view topics"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Module Details
              },
            ),
          ),
        ),
      ],
    );
  }
}

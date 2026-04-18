import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_service.dart';

class ModuleDetailsScreen extends StatelessWidget {
  final Module module;
  const ModuleDetailsScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit-module', extra: module),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Priority: ${module.priority}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const Divider(height: 40),
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
              module.description.isEmpty
                  ? 'No description.'
                  : module.description,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Module?'),
        content: const Text(
          'This will remove it from the library. Mappings in Subjects will need manual cleanup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ModuleService().deleteModule(module.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

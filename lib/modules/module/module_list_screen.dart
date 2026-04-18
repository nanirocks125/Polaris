import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_service.dart';

class ModuleListScreen extends StatelessWidget {
  const ModuleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleService = ModuleService();

    return Scaffold(
      appBar: AppBar(title: const Text('Module Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, moduleService),
        label: const Text('New Module'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Module>>(
        stream: moduleService.getModulesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final modules = snapshot.data ?? [];
          if (modules.isEmpty) {
            return const Center(child: Text('No modules added yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.view_module)),
                  title: Text(
                    module.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    module.description.isEmpty
                        ? 'No description'
                        : module.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/module-details', extra: module),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Quick Create Logic ---
  void _showCreateDialog(BuildContext context, ModuleService service) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Create Module'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Module Title (e.g. Fundamental Rights)',
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
                // Create the module directly
                await service.createModule(
                  Module(
                    title: titleController.text.trim(),
                    description: '', // Default empty for quick create
                  ),
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

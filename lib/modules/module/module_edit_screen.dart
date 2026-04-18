import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_service.dart';

class ModuleEditScreen extends StatefulWidget {
  final Module? module; // Null means we are creating
  const ModuleEditScreen({super.key, this.module});

  @override
  State<ModuleEditScreen> createState() => _ModuleEditScreenState();
}

class _ModuleEditScreenState extends State<ModuleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.module?.title ?? '');
    _descController = TextEditingController(
      text: widget.module?.description ?? '',
    );
    _priorityController = TextEditingController(
      text: (widget.module?.priority ?? 0).toString(),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final moduleData = Module(
      id: widget.module?.id ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: int.tryParse(_priorityController.text) ?? 0,
    );

    final service = ModuleService();
    if (widget.module == null) {
      await service.createModule(moduleData);
    } else {
      await service.updateModule(moduleData);
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module == null ? 'New Module' : 'Edit Module'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Module Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Title required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priorityController,
              decoration: const InputDecoration(
                labelText: 'Priority (Ordering)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _save, child: const Text('Save Module')),
          ],
        ),
      ),
    );
  }
}

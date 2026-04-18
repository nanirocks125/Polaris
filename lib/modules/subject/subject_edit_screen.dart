import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/subject/model/subject.dart';
import 'package:polaris/modules/subject/subject_service.dart';

class SubjectEditScreen extends StatefulWidget {
  final Subject subject;
  const SubjectEditScreen({super.key, required this.subject});

  @override
  State<SubjectEditScreen> createState() => _SubjectEditScreenState();
}

class _SubjectEditScreenState extends State<SubjectEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _isGS;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.title);
    _descController = TextEditingController(text: widget.subject.description);
    _isGS = widget.subject.isGeneralStudies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Subject'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final updated = Subject(
                id: widget.subject.id,
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                isGeneralStudies: _isGS,
                iconName: widget.subject.iconName,
              );
              await SubjectService().updateSubject(updated);
              if (mounted) context.pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('General Studies Content'),
            subtitle: const Text('Uncheck if this is an Optional subject'),
            value: _isGS,
            onChanged: (val) => setState(() => _isGS = val),
          ),
        ],
      ),
    );
  }
}

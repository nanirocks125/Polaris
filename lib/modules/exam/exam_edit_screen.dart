import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';

class ExamEditScreen extends StatefulWidget {
  final Exam exam;
  const ExamEditScreen({super.key, required this.exam});

  @override
  State<ExamEditScreen> createState() => _ExamEditScreenState();
}

class _ExamEditScreenState extends State<ExamEditScreen> {
  final ExamService _examService = ExamService();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;

  late List<ExamPhase> _phases;
  late Map<String, String> _resourceLinks;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.exam.title);
    _descController = TextEditingController(text: widget.exam.description);
    _selectedDate = widget.exam.targetDate;
    _phases = List.from(widget.exam.phases);
    _resourceLinks = Map.from(widget.exam.resourceLinks);
  }

  Future<void> _saveExam() async {
    if (_titleController.text.trim().isEmpty) return;

    final updatedExam = Exam(
      id: widget.exam.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      targetDate: _selectedDate,
      phases: [],
      resourceLinks: _resourceLinks,
      isActive: widget.exam.isActive,
      targetRecallPercentage: widget.exam.targetRecallPercentage,
      themeColorHex: widget.exam.themeColorHex,
    );

    await _examService.updateExam(updatedExam);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which phases are still available to be added
    final availablePhases = ExamPhase.values
        .where((phase) => !_phases.contains(phase))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exam'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveExam),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Exam Title',
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
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Schedule'),
          ListTile(
            title: const Text('Target Date'),
            subtitle: Text(_selectedDate.toLocal().toString().split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(4),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 1825)),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),

          const SizedBox(height: 24),

          // Phases Section with Dropdown Logic
          _buildSectionHeader('Exam Phases'),
          Wrap(
            spacing: 8,
            children: _phases
                .map(
                  (p) => InputChip(
                    label: Text(p.label),
                    onDeleted: () => setState(() => _phases.remove(p)),
                    deleteIconColor: Colors.redAccent,
                  ),
                )
                .toList(),
          ),

          if (availablePhases.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DropdownButton<ExamPhase>(
                hint: const Text("Add a phase..."),
                isExpanded: true,
                underline: Container(height: 1, color: Colors.grey),
                items: availablePhases.map((phase) {
                  return DropdownMenuItem(
                    value: phase,
                    child: Text(phase.label),
                  );
                }).toList(),
                onChanged: (ExamPhase? newValue) {
                  if (newValue != null) {
                    setState(() => _phases.add(newValue));
                  }
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "All phases added",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          const SizedBox(height: 32),
          _buildSectionHeader('Resource Links'),
          ..._resourceLinks.entries.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () =>
                      setState(() => _resourceLinks.remove(entry.key)),
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _addNewResource,
            icon: const Icon(Icons.link),
            label: const Text('Add Resource Link'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  void _addNewResource() {
    final keyController = TextEditingController();
    final valController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Resource'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                hintText: 'Label (e.g. Confluence)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: valController,
              decoration: const InputDecoration(hintText: 'URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (keyController.text.isNotEmpty) {
                setState(
                  () => _resourceLinks[keyController.text] = valController.text,
                );
              }
              context.pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';
import 'package:polaris/modules/exam/phase_details.dart'; // Import PhaseDetail

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

  late bool _isActive;
  late double _targetRecall;
  late TextEditingController _colorController;

  // Changed from List<ExamPhase> to List<PhaseDetail>
  late List<PhaseDetail> _phaseDetails;
  late Map<String, String> _resourceLinks;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.exam.title);
    _descController = TextEditingController(text: widget.exam.description);
    _selectedDate = widget.exam.targetDate;

    // Deep copy the phases to avoid direct mutation of the widget property
    _phaseDetails = widget.exam.phases
        .map(
          (p) => PhaseDetail(
            phase: p.phase,
            totalMarks: p.totalMarks,
            previousCutoff: p.previousCutoff,
            papers: List.from(p.papers),
          ),
        )
        .toList();

    _isActive = widget.exam.isActive;
    _targetRecall = widget.exam.targetRecallPercentage.toDouble();
    _colorController = TextEditingController(text: widget.exam.themeColorHex);

    _resourceLinks = Map.from(widget.exam.resourceLinks);
  }

  Future<void> _saveExam() async {
    if (_titleController.text.trim().isEmpty) return;

    final updatedExam = Exam(
      id: widget.exam.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      targetDate: _selectedDate,
      phases:
          _phaseDetails, // Correctly passing the list of PhaseDetail objects
      resourceLinks: _resourceLinks,
      isActive: widget.exam.isActive,
      targetRecallPercentage: widget.exam.targetRecallPercentage,
      themeColorHex: widget.exam.themeColorHex,
      subjects: widget.exam.subjects, // Preserve subjects
      lastStudiedAt: widget.exam.lastStudiedAt,
    );

    await _examService.updateExam(updatedExam);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Check which enum values are not yet represented in our _phaseDetails list
    final usedPhases = _phaseDetails.map((p) => p.phase).toSet();
    final availablePhases = ExamPhase.values
        .where((phase) => !usedPhases.contains(phase))
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
          _buildSectionHeader('General Info'),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Exam Title'),
          ),
          const SizedBox(height: 16),

          // Is Active & Recall Goal
          SwitchListTile(
            title: const Text("Set as Active Exam"),
            subtitle: const Text(
              "Determines if this appears on your dashboard",
            ),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),

          _buildSectionHeader('Study Goals'),
          Text("Target Recall: ${_targetRecall.toInt()}%"),
          Slider(
            value: _targetRecall,
            min: 50,
            max: 100,
            divisions: 10,
            label: "${_targetRecall.toInt()}%",
            onChanged: (v) => setState(() => _targetRecall = v),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Appearance'),
          TextField(
            controller: _colorController,
            decoration: const InputDecoration(
              labelText: 'Theme Color Hex',
              prefixText: '# ',
              helperText: 'e.g. 2196F3',
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Phases (Tap to edit marks)'),
          ..._phaseDetails.map(
            (pd) => ListTile(
              title: Text(pd.phase.label),
              subtitle: Text(
                "${pd.totalMarks} Marks • ${pd.papers.length} Papers",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _editPhaseSpecifics(pd),
              ),
              onTap: () => _editPhaseSpecifics(pd),
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
            onTap: _selectDate,
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('Exam Phases'),
          Wrap(
            spacing: 8,
            children: _phaseDetails
                .map(
                  (p) => InputChip(
                    label: Text(p.phase.label),
                    onDeleted: () => setState(() => _phaseDetails.remove(p)),
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
                    setState(() {
                      // Wrap the enum in a PhaseDetail object
                      _phaseDetails.add(PhaseDetail(phase: newValue));
                    });
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
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

  void _editPhaseSpecifics(PhaseDetail pd) {
    final marksController = TextEditingController(
      text: pd.totalMarks.toString(),
    );
    final cutoffController = TextEditingController(
      text: pd.previousCutoff?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${pd.phase.label} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: marksController,
              decoration: const InputDecoration(labelText: 'Total Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: cutoffController,
              decoration: const InputDecoration(labelText: 'Previous Cutoff'),
              keyboardType: TextInputType.number,
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
              setState(() {
                pd.totalMarks = int.tryParse(marksController.text) ?? 0;
                pd.previousCutoff = double.tryParse(cutoffController.text);
              });
              context.pop();
            },
            child: const Text('Update'),
          ),
        ],
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
              decoration: const InputDecoration(hintText: 'Label (e.g. Wiki)'),
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

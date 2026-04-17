import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';

class ExamManagementScreen extends StatefulWidget {
  const ExamManagementScreen({super.key});

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen> {
  final ExamService _examService = ExamService();

  // Displays the Create/Edit form in a Dialog
  void _showExamForm([Exam? existingExam]) {
    final titleController = TextEditingController(
      text: existingExam?.title ?? '',
    );
    final descController = TextEditingController(
      text: existingExam?.description ?? '',
    );
    DateTime selectedDate = existingExam?.targetDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingExam == null ? 'Create Exam' : 'Edit Exam'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Exam Title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Target Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 1825),
                              ),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    final newExam = Exam(
                      id: existingExam?.id ?? '', // Preserve ID if editing
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      targetDate: selectedDate,
                    );

                    if (existingExam == null) {
                      await _examService.createExam(newExam);
                    } else {
                      await _examService.updateExam(newExam);
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Deletion Confirmation
  void _confirmDelete(Exam exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exam?'),
        content: Text('Are you sure you want to delete ${exam.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _examService.deleteExam(exam.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExamForm(),
        icon: const Icon(Icons.add),
        label: const Text('New Exam'),
      ),
      body: StreamBuilder<List<Exam>>(
        stream: _examService.getExamsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final exams = snapshot.data ?? [];

          if (exams.isEmpty) {
            return const Center(child: Text('No exams created yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    context.push('/exam-details', extra: exam);
                  },
                  title: Text(
                    exam.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${exam.description}\nTarget: ${exam.targetDate.toLocal().toString().split(' ')[0]}',
                  ),
                  isThreeLine: exam.description.isNotEmpty,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

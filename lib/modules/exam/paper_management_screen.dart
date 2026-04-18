import 'package:flutter/material.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/model/paper.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/phase_details.dart';

class PaperManagementScreen extends StatelessWidget {
  final Exam exam;
  final PhaseDetail phase;

  const PaperManagementScreen({
    super.key,
    required this.exam,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${phase.phase.label} Papers")),
      body: ListView.builder(
        itemCount: phase.papers.length,
        itemBuilder: (context, index) {
          final paper = phase.papers[index];
          return ListTile(
            title: Text(paper.title),
            subtitle: Text("${paper.subjects.length} Subjects Linked"),
            trailing: const Icon(Icons.edit),
            onTap: () => _openPaperEditor(context, paper),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPaperEditor(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openPaperEditor(BuildContext context, Paper? paper) {
    // Navigate to a screen where you can:
    // 1. Edit Paper Name/Marks
    // 2. Select Subjects from Exam.subjects master list
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';
import 'package:polaris/modules/exam/phase_details.dart';

class ExamDetailsScreen extends StatelessWidget {
  final Exam exam;
  final ExamService _examService = ExamService();

  ExamDetailsScreen({super.key, required this.exam});

  Color _getThemeColor() {
    try {
      return Color(int.parse(exam.themeColorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Exam?'),
        content: Text(
          'This will permanently delete "${exam.title}" and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _examService.deleteExam(exam.id);
              if (context.mounted) {
                Navigator.pop(dialogContext);
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    final daysRemaining = exam.targetDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/edit-exam', extra: exam),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(24.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exam.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildCountdownBadge(daysRemaining, themeColor),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                exam.description.isEmpty
                    ? "No description provided."
                    : exam.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  _buildInfoTile(
                    context,
                    "Target Date",
                    exam.targetDate.toLocal().toString().split(' ')[0],
                    Icons.event,
                    themeColor,
                  ),
                  const SizedBox(width: 16),
                  _buildInfoTile(
                    context,
                    "Recall Goal",
                    "${exam.targetRecallPercentage}%",
                    Icons.psychology_outlined,
                    themeColor,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildInfoTile(
                context,
                "Status",
                exam.isActive ? "ACTIVE" : "INACTIVE",
                Icons.radio_button_checked,
                exam.isActive ? Colors.green : Colors.grey,
              ),

              _buildSectionLabel(context, "Phases & Marks"),
              const SizedBox(height: 12),
              if (exam.phases.isEmpty)
                const Text("No phases defined.")
              else
                ...exam.phases.map(
                  (phase) => _buildPhaseCard(context, phase, themeColor),
                ),

              const SizedBox(height: 32),

              _buildSectionLabel(context, "Quick Links & Resources"),
              const SizedBox(height: 12),
              ...exam.resourceLinks.entries.map(
                (entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.link, color: themeColor),
                    title: Text(entry.key),
                    subtitle: Text(
                      entry.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () {
                      // url_launcher logic here
                    },
                  ),
                ),
              ),
              if (exam.resourceLinks.isEmpty)
                const Text("No resources linked."),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push('/manage-subjects', extra: exam),
                icon: const Icon(Icons.list_alt),
                label: const Text("Manage Master Subject List"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- New UI Components for Model Updates ---

  Widget _buildPhaseCard(
    BuildContext context,
    PhaseDetail detail,
    Color themeColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: themeColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: themeColor.withOpacity(0.1),
              child: Text(
                detail.phase.label[0],
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.phase.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${detail.papers.length} Papers • ${detail.totalMarks} Total Marks",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (detail.previousCutoff != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Prev. Cutoff",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    detail.previousCutoff.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    final bool active = exam.isActive;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? Colors.amber.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active
              ? Colors.amber.withOpacity(0.5)
              : Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.bolt : Icons.pause_circle_outline,
            size: 14,
            color: active ? Colors.amber : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            active ? "ACTIVE EXAM" : "INACTIVE",
            style: TextStyle(
              color: active ? Colors.amber : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildCountdownBadge(int days, Color color) {
    bool isPast = days < 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPast ? Colors.red.withOpacity(0.1) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isPast ? Colors.red : color),
      ),
      child: Text(
        isPast ? "COMPLETED" : "$days DAYS LEFT",
        style: TextStyle(
          color: isPast ? Colors.red : color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

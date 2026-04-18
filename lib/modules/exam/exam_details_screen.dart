import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';

class ExamDetailsScreen extends StatelessWidget {
  final Exam exam;
  final ExamService _examService = ExamService();

  ExamDetailsScreen({super.key, required this.exam});

  // Helper to convert hex string to Color
  Color _getThemeColor() {
    try {
      return Color(int.parse(exam.themeColorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue; // Fallback
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
                context.pop(); // Return to Management Screen
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
        backgroundColor: Colors.transparent,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section: Title and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exam.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildCountdownBadge(daysRemaining, themeColor),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              exam.description.isEmpty
                  ? "No description provided."
                  : exam.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Info Grid
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
                  "Last Studied",
                  exam.lastStudiedAt != null
                      ? exam.lastStudiedAt!.toLocal().toString().split(' ')[0]
                      : "Not yet",
                  Icons.history,
                  themeColor,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Phases Section
            _buildSectionLabel(context, "Phases"),

            // const SizedBox(height: 12),
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: exam.phases
            //       .map(
            //         (phase) => Chip(
            //           label: Text(phase.label),
            //           backgroundColor: themeColor.withOpacity(0.1),
            //           side: BorderSide(color: themeColor.withOpacity(0.5)),
            //         ),
            //       )
            //       .toList(),
            // ),
            // if (exam.phases.isEmpty) const Text("No phases defined."),
            const SizedBox(height: 32),

            // Resources Section
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
                    // TODO: Use url_launcher to open entry.value
                  },
                ),
              ),
            ),
            if (exam.resourceLinks.isEmpty) const Text("No resources linked."),
          ],
        ),
      ),
    );
  }

  // UI Components
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
    return Expanded(
      child: Container(
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
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

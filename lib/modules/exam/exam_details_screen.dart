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
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, themeColor, daysRemaining),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildSectionLabel(context, "Performance Goals"),
                  const SizedBox(height: 12),
                  _buildStatsSection(context, themeColor),

                  const SizedBox(height: 32),
                  _buildSectionLabel(context, "Preparation Phases"),
                  const SizedBox(height: 12),
                  if (exam.phases.isEmpty)
                    const Text("No phases defined.")
                  else
                    ...exam.phases.map(
                      (phase) => _buildPhaseCard(context, phase, themeColor),
                    ),

                  const SizedBox(height: 32),
                  _buildSectionLabel(context, "Quick Links"),
                  const SizedBox(height: 12),
                  _buildResourcesGrid(themeColor),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Big Hero Header for Title and Description
  Widget _buildHeaderSection(BuildContext context, Color themeColor, int days) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusHeader(),
          Text(
            exam.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exam.description.isEmpty
                ? "No description provided."
                : exam.description,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Big Stats Row for Date and Recall
  Widget _buildStatsSection(BuildContext context, Color themeColor) {
    return Row(
      children: [
        Expanded(
          child: _buildBigStatCard(
            context,
            "Target Date",
            exam.targetDate.toLocal().toString().split(' ')[0],
            Icons.calendar_today_rounded,
            themeColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBigStatCard(
            context,
            "Recall Goal",
            "${exam.targetRecallPercentage}%",
            Icons.insights_rounded,
            Colors.orangeAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildBigStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 3. Informative Phase Cards
  Widget _buildPhaseCard(
    BuildContext context,
    PhaseDetail detail,
    Color themeColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(
          '/manage-papers',
          extra: {'exam': exam, 'phase': detail},
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    detail.phase.label[0],
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.phase.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${detail.papers.length} Papers • ${detail.totalSubjectsCount} Subjects",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Compact Resource Grid
  Widget _buildResourcesGrid(Color themeColor) {
    if (exam.resourceLinks.isEmpty) return const Text("No resources linked.");

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: exam.resourceLinks.length,
      itemBuilder: (context, index) {
        String key = exam.resourceLinks.keys.elementAt(index);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.link, size: 18, color: themeColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  key,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- New UI Components for Model Updates ---
  /*
  Widget _buildPhaseCard(
    BuildContext context,
    PhaseDetail detail,
    Color themeColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias, // Ensures ink splash follows border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: themeColor.withOpacity(0.2)),
      ),
      child: ListTile(
        // Using ListTile inside Card for easy onTap behavior
        onTap: () => context.push(
          '/manage-papers',
          extra: {'exam': exam, 'phase': detail},
        ),
        leading: CircleAvatar(
          backgroundColor: themeColor.withOpacity(0.1),
          child: Text(
            detail.phase.label[0],
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          detail.phase.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${detail.papers.length} Papers • ${detail.totalSubjectsCount} Subjects",
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
*/
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
}

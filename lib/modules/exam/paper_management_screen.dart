import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_service.dart';
import 'package:polaris/modules/exam/phase_details.dart';
import 'package:polaris/modules/exam/paper.dart';
import 'package:polaris/modules/subject/model/subject.dart';
import 'package:polaris/modules/subject/subject_service.dart';
import 'package:uuid/uuid.dart';

class PaperManagementScreen extends StatefulWidget {
  final Exam exam;
  final PhaseDetail phase;

  const PaperManagementScreen({
    super.key,
    required this.exam,
    required this.phase,
  });

  @override
  State<PaperManagementScreen> createState() => _PaperManagementScreenState();
}

class _PaperManagementScreenState extends State<PaperManagementScreen> {
  final ExamService _examService = ExamService();
  final SubjectService _subjectService = SubjectService();

  Future<void> _save() async {
    await _examService.updateExam(widget.exam);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.phase.phase.label} Papers"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Colors.greenAccent),
            onPressed: _save,
          ),
        ],
      ),
      body: widget.phase.papers.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: widget.phase.papers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final paper = widget.phase.papers[index];
                return _buildPaperSection(paper, themeColor);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewPaper,
        label: const Text("New Paper"),
        icon: const Icon(Icons.add),
        backgroundColor: themeColor,
      ),
    );
  }

  // 1. The Paper Section Card
  Widget _buildPaperSection(Paper paper, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildPaperHeader(paper, themeColor),

          // Subjects List
          if (paper.subjects.isEmpty)
            _buildEmptySubjectPlaceholder(paper)
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                children: paper.subjects
                    .map((s) => _buildSubjectItem(s, paper))
                    .toList(),
              ),
            ),

          // Action Footer
          _buildPaperFooter(paper, themeColor),
        ],
      ),
    );
  }

  // 1. Placeholder when a specific Paper has no subjects linked yet
  Widget _buildEmptySubjectPlaceholder(Paper paper) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.library_books_outlined,
              color: Colors.grey.withOpacity(0.3),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              "No subjects linked to this paper",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Empty state for the entire screen (when no papers exist for the phase)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(height: 20),
            Text(
              "No Papers Defined",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Start by adding a paper like 'General Studies' or 'Arithmetic Ability'.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Helper to get the theme color (if not already in your State class)
  Color _getThemeColor() {
    try {
      return Color(
        int.parse(widget.exam.themeColorHex.replaceFirst('#', '0xFF')),
      );
    } catch (e) {
      return Colors.blue;
    }
  }

  // 2. Clear Header with Stats
  Widget _buildPaperHeader(Paper paper, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paper.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${paper.subjects.length} Subjects Linked",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${paper.maxMarks} Marks",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Compact Subject Item
  Widget _buildSubjectItem(dynamic subject, Paper paper) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book_rounded, size: 16, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(subject.title, style: const TextStyle(fontSize: 14)),
          ),
          IconButton(
            onPressed: () => setState(() => paper.subjects.remove(subject)),
            icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // 4. Clean Footer for Adding Subjects
  Widget _buildPaperFooter(Paper paper, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: InkWell(
        onTap: () => _showSubjectPicker(paper),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: themeColor.withOpacity(0.3),
              style: BorderStyle.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 18, color: themeColor),
              const SizedBox(width: 8),
              Text(
                "Link Subject",
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewPaper() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Paper Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g. GS Paper 1"),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(
                () => widget.phase.papers.add(
                  Paper(
                    id: const Uuid().v4(),
                    title: controller.text,
                    subjects: [],
                  ),
                ),
              );
              context.pop();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showSubjectPicker(Paper paper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to expand properly
      backgroundColor: Colors.transparent, // We'll use our own decoration
      builder: (ctx) {
        return StreamBuilder<List<Subject>>(
          // FETCHING: This is where the magic happens. We fetch the latest exam data.
          stream: _subjectService.getSubjectsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // 1. Get the Master List from the fresh data
            final masterSubjects = snapshot.data ?? [];

            // 2. Filter: Only show subjects NOT already in this paper
            final available = masterSubjects
                .where(
                  (master) => !paper.subjects.any((s) => s.id == master.id),
                )
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7, // 70% of screen
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar for visual polish
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    "Link Master Subject",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),

                  if (available.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          masterSubjects.isEmpty
                              ? "No subjects in Master List.\nAdd them in 'Manage Master Subject List' first."
                              : "All master subjects are already linked.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: available.length,
                        itemBuilder: (ctx, i) {
                          final subject = available[i];
                          return ListTile(
                            leading: const Icon(Icons.add_link_outlined),
                            title: Text(subject.title),
                            subtitle: const Text("Tap to link to this paper"),
                            onTap: () {
                              setState(() {
                                // Link the subject to the paper
                                paper.subjects.add(subject.snapshot);
                              });
                              context.pop(); // Close picker
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/provider/app_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:polaris/modules/exam/exam_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppUserProvider>().user;
    final activeExam = user?.activeExam;

    if (activeExam == null) {
      return const Scaffold(
        body: Center(child: Text('Please select an active exam from Profile.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Hero Analytics Section
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(context, activeExam),
              title: Text(
                activeExam.title,
                style: const TextStyle(fontSize: 16),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),

          // 2. Detailed Analytics from Master Doc
          StreamBuilder<Exam>(
            stream: ExamService().getExamStream(activeExam.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('Exam details not found.')),
                );
              }

              final exam = snapshot.data!;
              return SliverList(
                delegate: SliverChildListDelegate([
                  _buildCountdownCard(context, exam.targetDate),
                  _buildPhaseBreakdown(context, exam),
                  _buildRecentActivity(context),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildHeroSection(BuildContext context, dynamic activeExam) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).primaryColor, Colors.blueGrey.shade900],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Overall Circular Progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: activeExam.progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.greenAccent,
                      ),
                    ),
                  ),
                  Text(
                    '${(activeExam.progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Mastery',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Level 4',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '70% Recall Goal',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(BuildContext context, DateTime targetDate) {
    final daysLeft = targetDate.difference(DateTime.now()).inDays;
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(
          Icons.timer_outlined,
          size: 32,
          color: Colors.orange,
        ),
        title: Text(
          '$daysLeft Days Left',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          'Target: ${DateFormat('dd MMM yyyy').format(targetDate)}',
        ),
        trailing: const Icon(Icons.flag_circle, color: Colors.grey),
      ),
    );
  }

  Widget _buildPhaseBreakdown(BuildContext context, Exam exam) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Syllabus Health',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...exam.phases.map((phase) {
            // Calculate phase progress based on papers
            double phaseProgress = phase.papers.isEmpty
                ? 0.0
                : phase.papers
                          .map((p) => p.completionPercentage)
                          .reduce((a, b) => a + b) /
                      (phase.papers.length * 100);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        phase.phase.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${(phaseProgress * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: phaseProgress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return const ListTile(
      title: Text('Recent Topics'),
      subtitle: Text('History (Modern India) - 2 days ago'),
      trailing: Icon(Icons.history),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polaris/components/scaffold_global_drawer.dart';
import 'package:polaris/modules/dashboard/dashboard.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_details_screen.dart';
import 'package:polaris/modules/exam/exam_edit_screen.dart';
import 'package:polaris/modules/exam/exam_management_screen.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_details_screen.dart';
import 'package:polaris/modules/module/module_edit_screen.dart';
import 'package:polaris/modules/module/module_list_screen.dart';
import 'package:polaris/modules/subject/subject.dart';
import 'package:polaris/modules/subject/subject_details_screen.dart';
import 'package:polaris/modules/subject/subject_edit_screen.dart';
import 'package:polaris/modules/subject/subject_list_screen.dart';
import 'package:polaris/modules/topic/topic.dart';
import 'package:polaris/modules/topic/topic_details_screen.dart';
import 'package:polaris/modules/topic/topic_edit_screen.dart';
import 'package:polaris/modules/topic/topic_list_screen.dart';
import 'modules/authentication/login_screen.dart';

// 1. A helper class that tells the router to refresh whenever Firebase Auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// 2. The main router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Listen to Firebase Auth state changes
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  // The Global Auth Guard
  redirect: (context, state) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final bool isGoingToLogin = state.uri.toString() == '/login';

    // Rule A: Not logged in? Go to login page.
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }
    // Rule B: Already logged in but trying to reach login page? Go to dashboard.
    if (isLoggedIn && isGoingToLogin) {
      return '/exams';
    }
    // Rule C: Otherwise, proceed as normal.
    return null;
  },

  // 3. Define your routes here
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    ShellRoute(
      builder: (context, state, child) {
        // Wrap the child (the page) in our ScaffoldWithDrawer
        return ScaffoldGlobalDrawer(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const DashboardScreen(), // We will build this next
          routes: [
            // Sub-routes will go here later, e.g.:
            // GoRoute(path: 'campaign/:topicId', builder: ...)
          ],
        ),
        GoRoute(
          path: '/exams',
          builder: (context, state) => const ExamManagementScreen(),
        ),
        GoRoute(
          path: '/exam-details',
          builder: (context, state) {
            // Extract the exam object passed during navigation
            final exam = state.extra as Exam;
            return ExamDetailsScreen(exam: exam);
          },
        ),
        GoRoute(
          path: '/edit-exam',
          builder: (context, state) {
            final exam = state.extra as Exam;
            return ExamEditScreen(exam: exam);
          },
        ),
        GoRoute(
          path: '/subjects',
          builder: (context, state) => const SubjectListScreen(),
        ),
        GoRoute(
          path: '/subject-details',
          builder: (context, state) =>
              SubjectDetailsScreen(subject: state.extra as Subject),
        ),
        GoRoute(
          path: '/edit-subject',
          builder: (context, state) =>
              SubjectEditScreen(subject: state.extra as Subject),
        ),
        GoRoute(
          path: '/modules',
          builder: (context, state) => const ModuleListScreen(),
        ),
        GoRoute(
          path: '/module-details',
          builder: (context, state) =>
              ModuleDetailsScreen(module: state.extra as Module),
        ),
        GoRoute(
          path: '/edit-module',
          builder: (context, state) =>
              ModuleEditScreen(module: state.extra as Module),
        ),

        GoRoute(
          path: '/topics',
          builder: (context, state) => const TopicListScreen(),
        ),
        GoRoute(
          path: '/topic-details',
          builder: (context, state) =>
              TopicDetailsScreen(topic: state.extra as Topic),
        ),
        GoRoute(
          path: '/edit-topic',
          builder: (context, state) {
            return TopicEditScreen(topic: state.extra as Topic);
          },
        ),
      ],
    ),
  ],
);

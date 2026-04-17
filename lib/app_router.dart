import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polaris/components/scaffold_global_drawer.dart';
import 'package:polaris/modules/dashboard/dashboard.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_details_screen.dart';
import 'package:polaris/modules/exam/exam_management_screen.dart';
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
      ],
    ),
  ],
);

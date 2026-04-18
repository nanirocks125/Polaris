import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:polaris/modules/user/app_user.dart';
import 'package:polaris/modules/user/app_user_service.dart';

class AppUserProvider extends ChangeNotifier {
  AppUser? _user;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AppUser>? _userSubscription;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  AppUserProvider() {
    // 1. Listen to Firebase Auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      firebaseUser,
    ) {
      if (firebaseUser != null) {
        _listenToUserDoc(firebaseUser.uid);
      } else {
        _user = null;
        _userSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  // 2. Real-time stream from Firestore for the specific user doc
  void _listenToUserDoc(String uid) {
    _userSubscription?.cancel();
    _userSubscription = AppUserService(uid: uid).getUserStream().listen((
      userData,
    ) {
      _user = userData;
      notifyListeners(); // UI updates whenever Firestore doc changes
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.dispose();
  }
}

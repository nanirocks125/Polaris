import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/user/app_user.dart';
import 'package:polaris/modules/user/app_user_settings.dart';

class AppUserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid; // Pass the Firebase Auth UID

  AppUserService({required this.uid});

  DocumentReference<Map<String, dynamic>> get _userRef =>
      _db.collection('users').doc(uid);

  // Stream for real-time UI updates (e.g., Profile Screen)
  Stream<AppUser> getUserStream() {
    return _userRef.snapshots().map((doc) {
      if (!doc.exists) throw Exception("User not found");
      return AppUser.fromJson(doc.data()!)..id = doc.id;
    });
  }

  // --- Actions ---

  // switching the current exam context
  Future<void> switchActiveExam(String examId) async {
    await _userRef.update({'activeExamId': examId});
  }

  // Update specific settings without rewriting the whole user doc
  Future<void> updateSettings(AppUserSettings settings) async {
    await _userRef.update({'settings': settings.toJson()});
  }

  // Edit basic profile details
  Future<void> updateProfile({String? name, String? email}) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    await _userRef.update(data);
  }
}

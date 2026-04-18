import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/exam/exam.dart';
import 'package:polaris/modules/exam/exam_snapshot.dart';
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

  // Fetch all users for the Admin list
  Stream<List<AppUser>> getAllUsersStream() {
    return _db
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppUser.fromJson(doc.data())..id = doc.id)
              .toList(),
        );
  }

  // Assign an exam to a specific user
  Future<void> assignExamToUser(String userId, Exam exam) async {
    // 1. Create the Snapshot
    final snapshot = ExamSnapshot(
      id: exam.id,
      title: exam.title,
      themeColorHex: exam.themeColorHex,
      progress: 0.0, // New assignment starts at 0
    );

    // 2. Update user document
    await _db.collection('users').doc(userId).update({
      'assignedExams': FieldValue.arrayUnion([snapshot.toJson()]),
      // Automatically set as active if it's their first exam
      'activeExam': snapshot.toJson(),
    });
  }

  // Inside UserService
  Future<void> switchActiveExam(ExamSnapshot exam) async {
    await _userRef.update({
      'activeExam': exam.toJson(), // Entire snapshot updated for instant access
    });
  }
}

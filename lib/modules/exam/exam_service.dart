import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/exam/exam.dart';

class ExamService {
  final CollectionReference<Map<String, dynamic>> _examsRef = FirebaseFirestore
      .instance
      .collection('exams');

  /// Retrieves a live stream of all exams
  Stream<List<Exam>> getExamsStream() {
    return _examsRef
        .orderBy('targetDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Exam.fromFirestore(doc)).toList(),
        );
  }

  /// Creates a new exam and injects the auto-generated ID before saving
  Future<void> createExam(Exam exam) async {
    // 1. Generate a new document reference (this safely creates a unique ID locally)
    final newDocRef = _examsRef.doc();

    // 2. Assign the generated ID to your exam object
    exam.id = newDocRef.id;

    // 3. Convert your object to a Map
    final Map<String, dynamic> examData = exam.toJson();

    // 4. Write the data to Firestore using .set() instead of .add()
    await newDocRef.set(examData);
  }

  /// Updates an existing exam based on its injected ID
  Future<void> updateExam(Exam exam) async {
    if (exam.id.isEmpty) throw Exception("Cannot update an exam without an ID");
    await _examsRef.doc(exam.id).update(exam.toJson());
  }

  /// Deletes an exam by its ID
  Future<void> deleteExam(String examId) async {
    await _examsRef.doc(examId).delete();
  }
}

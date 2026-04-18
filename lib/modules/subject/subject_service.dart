import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/subject/subject.dart';

class SubjectService {
  final CollectionReference<Map<String, dynamic>> _subjectsRef =
      FirebaseFirestore.instance.collection('subjects');

  Stream<List<Subject>> getSubjectsStream() {
    return _subjectsRef
        .orderBy('title')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Subject.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createSubject(Subject subject) async {
    final docRef = _subjectsRef.doc();
    subject.id = docRef.id;
    await docRef.set(subject.toJson());
  }

  Future<void> updateSubject(Subject subject) async {
    if (subject.id.isEmpty) throw Exception("Subject ID is missing");
    await _subjectsRef.doc(subject.id).update(subject.toJson());
  }

  Future<void> deleteSubject(String id) async {
    await _subjectsRef.doc(id).delete();
  }
}

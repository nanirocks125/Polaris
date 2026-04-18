import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_snapshot.dart';
import 'package:polaris/modules/subject/model/subject.dart';

class SubjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _subjectsRef =
      FirebaseFirestore.instance.collection('subjects');
  final CollectionReference<Map<String, dynamic>> _modulesRef =
      FirebaseFirestore.instance.collection('modules');

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

  Future<void> linkModuleToSubject(Subject subject, Module module) async {
    final subjectDoc = _subjectsRef.doc(subject.id);
    final moduleDoc = _modulesRef.doc(module.id);

    return _db.runTransaction((transaction) async {
      // 1. Update Subject: Add ModuleSnapshot to the list
      transaction.update(subjectDoc, {
        'modules': FieldValue.arrayUnion([module.snapshot.toJson()]),
        'modulesCount': FieldValue.increment(1),
      });

      // 2. Update Module: Set the SubjectSnapshot
      transaction.update(moduleDoc, {'subject': subject.snapshot.toJson()});
    });
  }

  /// Atomically creates a NEW module and links it to the Subject
  Future<void> createAndLinkModule(Subject subject, String moduleTitle) async {
    final subjectDoc = _subjectsRef.doc(subject.id);
    final newModuleDoc = _modulesRef.doc(); // Auto-gen ID

    final newModule = Module(
      id: newModuleDoc.id,
      title: moduleTitle,
      description: "Auto-generated for ${subject.title}",
      subject: subject.snapshot,
    );

    return _db.runTransaction((transaction) async {
      // 1. Create the Module document
      transaction.set(newModuleDoc, newModule.toJson());

      // 2. Update the Subject list
      transaction.update(subjectDoc, {
        'modules': FieldValue.arrayUnion([newModule.snapshot.toJson()]),
        'modulesCount': FieldValue.increment(1),
      });
    });
  }

  /// Atomically unlinks a Module from a Subject
  Future<void> unlinkModuleFromSubject(
    Subject subject,
    ModuleSnapshot moduleSnapshot,
  ) async {
    final subjectDoc = _subjectsRef.doc(subject.id);
    final moduleDoc = _modulesRef.doc(moduleSnapshot.id);

    return _db.runTransaction((transaction) async {
      // 1. Remove from Subject's modules array
      transaction.update(subjectDoc, {
        'modules': FieldValue.arrayRemove([moduleSnapshot.toJson()]),
        'modulesCount': FieldValue.increment(-1),
      });

      // 2. Remove Subject reference from the Module document
      transaction.update(moduleDoc, {
        'subject': FieldValue.delete(), // Or set to null if using custom JSON
      });
    });
  }
}

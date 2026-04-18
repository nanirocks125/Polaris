import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/module/module.dart';

class ModuleService {
  final CollectionReference<Map<String, dynamic>> _moduleRef = FirebaseFirestore
      .instance
      .collection('modules');

  Stream<List<Module>> getModulesStream() {
    return _moduleRef
        .orderBy('priority')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Module.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createModule(Module module) async {
    await _moduleRef.add(module.toJson());
  }

  Future<void> updateModule(Module module) async {
    await _moduleRef.doc(module.id).update(module.toJson());
  }

  Future<void> deleteModule(String id) async {
    await _moduleRef.doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polaris/modules/topic/topic.dart';

class TopicService {
  final CollectionReference<Map<String, dynamic>> _topicRef = FirebaseFirestore
      .instance
      .collection('topics');

  Stream<List<Topic>> getTopicsStream() {
    return _topicRef
        .orderBy('title')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Topic.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createTopic(Topic topic) async {
    await _topicRef.add(topic.toJson());
  }

  Future<void> updateTopic(Topic topic) async {
    await _topicRef.doc(topic.id).update(topic.toJson());
  }

  Future<void> deleteTopic(String id) async {
    await _topicRef.doc(id).delete();
  }
}

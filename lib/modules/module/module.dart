import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/modules/module/module_snapshot.dart';
import 'package:polaris/modules/subject/model/subject_snapshot.dart';
import 'package:polaris/modules/topic/topic_snapshot.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  String id;

  String title;
  String description;
  int priority; // To keep "Basics" before "Advanced"

  int totalTopicsCount;
  int completedTopicsCount;

  final List<TopicSnapshot> topics; // Instant access to chapter list
  SubjectSnapshot? subject;

  Module({
    this.id = '',
    required this.title,
    required this.description,
    this.priority = 0,
    this.totalTopicsCount = 0,
    this.completedTopicsCount = 0,
    this.topics = const [],
    this.subject,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  factory Module.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Module data null");
    final module = Module.fromJson(data);
    module.id = doc.id;
    return module;
  }
}

extension ModuleExtension on Module {
  ModuleSnapshot get snapshot {
    return ModuleSnapshot(id: id, title: title);
  }
}

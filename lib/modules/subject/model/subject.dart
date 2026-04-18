import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/modules/module/module_snapshot.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {
  String id;

  String title;
  String? iconName; // e.g., "account_balance" for Polity
  String description;

  int modulesCount;
  int completedModulesCount;
  int totalTopicsCount;
  int completedTopicsCount;

  final List<ModuleSnapshot> modules; // Instant access to child titles

  // To distinguish between GS and Optional if needed
  bool isGeneralStudies;

  Subject({
    this.id = '',
    required this.title,
    this.iconName,
    this.description = '',
    this.isGeneralStudies = true,
    this.modulesCount = 0,
    this.completedModulesCount = 0,
    this.totalTopicsCount = 0,
    this.completedTopicsCount = 0,
    this.modules = const [],
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  factory Subject.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Subject data null");
    final subject = Subject.fromJson(data);
    subject.id = doc.id;
    return subject;
  }
}

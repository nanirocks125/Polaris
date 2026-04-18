import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/modules/module/module_snapshot.dart';
import 'package:polaris/modules/subject/subject_snapshot.dart';
import 'package:polaris/util/time_stamp_converter.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  String id;

  String title;
  String description;

  // --- Spaced Repetition (SRS) Fields ---
  int easeFactor; // Usually starts at 2.5
  int interval; // Days until next review
  bool isCompleted; // Added for progress tracking
  int repetitions;
  bool isHighYield;

  SubjectSnapshot? subject;
  ModuleSnapshot? module;

  @TimestampConverter()
  DateTime? lastReviewedAt;

  @TimestampConverter()
  DateTime? nextReviewDate;

  List<String> resourceLinks;

  Topic({
    this.id = '',
    required this.title,
    this.description = '',
    this.isCompleted = false, // Initialize as false
    this.easeFactor = 250, // Stored as int (2.5 * 100)
    this.isHighYield = false,
    this.interval = 0,
    this.repetitions = 0,
    this.lastReviewedAt,
    this.nextReviewDate,
    this.subject,
    this.resourceLinks = const [],
    this.module,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);

  factory Topic.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Topic data null");
    final topic = Topic.fromJson(data);
    topic.id = doc.id;
    return topic;
  }
}

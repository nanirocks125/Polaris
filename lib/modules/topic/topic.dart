import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
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

  @TimestampConverter()
  DateTime? lastReviewedAt;

  @TimestampConverter()
  DateTime? nextReviewDate;

  Topic({
    this.id = '',
    required this.title,
    this.description = '',
    this.easeFactor = 250, // Stored as int (2.5 * 100)
    this.interval = 0,
    this.lastReviewedAt,
    this.nextReviewDate,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);

  factory Topic.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Subject data null");
    final subject = Topic.fromJson(data);
    subject.id = doc.id;
    return subject;
  }
}

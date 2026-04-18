import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paper.g.dart';

@JsonSerializable()
class Paper {
  // id is kept in the model for easy access but excluded from JSON/DB body
  @JsonKey(includeToJson: false, includeFromJson: false)
  String id;

  String title; // e.g., "Paper-I: General Studies"
  String description;

  // Granular Exam Details
  int maxMarks; // e.g., 150
  int order; // For sorting: 1, 2, 3...

  // Aggregate Counters for Progress Tracking
  int totalSubjectsCount;
  int totalTopicsCount;
  int completedTopicsCount;

  Paper({
    this.id = '',
    required this.title,
    this.description = '',
    this.maxMarks = 150,
    this.order = 0,
    this.totalSubjectsCount = 0,
    this.totalTopicsCount = 0,
    this.completedTopicsCount = 0,
  });

  // Boilerplate for json_serializable
  factory Paper.fromJson(Map<String, dynamic> json) => _$PaperFromJson(json);

  Map<String, dynamic> toJson() => _$PaperToJson(this);

  // The "Senior Dev" Factory: Maps Firestore Doc ID to the model ID field
  factory Paper.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Paper data null for ID: ${doc.id}");

    return Paper.fromJson(data)..id = doc.id;
  }

  // Helper for UI Progress Calculation
  double get completionPercentage {
    if (totalTopicsCount == 0) return 0.0;
    return (completedTopicsCount / totalTopicsCount) * 100;
  }
}

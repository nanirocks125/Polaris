import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/phase_details.dart';
import 'package:polaris/modules/subject/subject_snapshot.dart';
import 'package:polaris/util/time_stamp_converter.dart';

part 'exam.g.dart';

@JsonSerializable(explicitToJson: true)
class Exam {
  String id;

  String title;
  String description;

  @TimestampConverter()
  DateTime targetDate;

  @TimestampConverter()
  DateTime? lastStudiedAt;

  List<PhaseDetail> phases;
  List<SubjectSnapshot> subjects;
  Map<String, String> resourceLinks;
  bool isActive;
  int targetRecallPercentage;
  String themeColorHex;

  Exam({
    this.id = '',
    required this.title,
    this.description = '',
    required this.targetDate,
    this.lastStudiedAt,
    this.phases = const [],
    this.isActive = false,
    this.targetRecallPercentage = 70, // Default to your 70% goal
    this.themeColorHex = '#2196F3', // Default Flutter Blue
    this.resourceLinks = const {},
    this.subjects = const [], // Default to empty list
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

  // Helper factory to parse directly from Firestore
  factory Exam.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Document data was null for ID: ${doc.id}");
    }
    final exam = Exam.fromJson(data);
    exam.id = doc.id; // Inject the document ID here perfectly
    return exam;
  }
}

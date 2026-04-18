import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/modules/exam/phase_details.dart';
import 'package:polaris/modules/subject/model/subject_snapshot.dart';
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

extension ExamExtension on Exam {
  /// Returns a unique list of all SubjectSnapshots across all phases and papers.
  List<SubjectSnapshot> get allSubjects {
    // We use a Map to keep track of unique subjects by ID
    // This ensures that if the same subject is in Prelims and Mains,
    // it only appears once in the final list.
    final Map<String, SubjectSnapshot> uniqueSubjectsMap = {};

    for (var phase in phases) {
      for (var paper in phase.papers) {
        for (var subject in paper.subjects) {
          // Store in map using ID as key; subsequent entries with
          // the same ID will simply overwrite (maintaining uniqueness)
          uniqueSubjectsMap[subject.id] = subject;
        }
      }
    }

    return uniqueSubjectsMap.values.toList();
  }

  /// Optional: Helper to get the total unique subject count
  int get totalSubjectsCount => allSubjects.length;
}

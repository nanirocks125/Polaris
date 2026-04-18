import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/modules/exam/paper.dart';
import 'package:polaris/modules/subject/model/subject_snapshot.dart';

part 'phase_details.g.dart';

@JsonSerializable(explicitToJson: true)
class PhaseDetail {
  final ExamPhase phase; // Using our Enum
  int totalMarks;
  double? previousCutoff;

  // Replacing List<String> with the Snapshots
  List<Paper> papers;

  PhaseDetail({
    required this.phase,
    this.totalMarks = 0,
    this.previousCutoff,
    this.papers = const [],
  });

  factory PhaseDetail.fromJson(Map<String, dynamic> json) =>
      _$PhaseDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PhaseDetailToJson(this);
}

extension PhaseDetailsExtension on PhaseDetail {
  /// Returns a unique list of all SubjectSnapshots across all phases and papers.
  List<SubjectSnapshot> get allSubjects {
    // We use a Map to keep track of unique subjects by ID
    // This ensures that if the same subject is in Prelims and Mains,
    // it only appears once in the final list.
    final Map<String, SubjectSnapshot> uniqueSubjectsMap = {};

    for (var paper in papers) {
      for (var subject in paper.subjects) {
        // Store in map using ID as key; subsequent entries with
        // the same ID will simply overwrite (maintaining uniqueness)
        uniqueSubjectsMap[subject.id] = subject;
      }
    }

    return uniqueSubjectsMap.values.toList();
  }

  /// Optional: Helper to get the total unique subject count
  int get totalSubjectsCount => allSubjects.length;
}

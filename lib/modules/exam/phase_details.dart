import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/enum/exam_phase.dart';
import 'package:polaris/model/paper.dart';

part 'phase_details.g.dart';

@JsonSerializable()
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

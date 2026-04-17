import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/model/topic.dart';

part 'subject.g.dart';

@JsonSerializable(explicitToJson: true)
class Subject {
  final String subjectId; // e.g., "indian_polity"
  final String title; // e.g., "Indian Constitution and Polity"

  // The magic happens here:
  // e.g., ['prelims', 'mains'] OR just ['mains']
  final List<String> examPhases;

  final List<Topic> topics;

  Subject({
    required this.subjectId,
    required this.title,
    required this.examPhases,
    required this.topics,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/model/subject.dart';

part 'syllabus.g.dart';

@JsonSerializable(explicitToJson: true)
class Syllabus {
  final String examName; // "APPSC Group 1"
  final List<Subject> subjects; // Unified list of all subjects

  Syllabus({required this.examName, required this.subjects});

  factory Syllabus.fromJson(Map<String, dynamic> json) =>
      _$SyllabusFromJson(json);
  Map<String, dynamic> toJson() => _$SyllabusToJson(this);
}

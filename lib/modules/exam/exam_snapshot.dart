import 'package:json_annotation/json_annotation.dart';

part 'exam_snapshot.g.dart';

@JsonSerializable()
class ExamSnapshot {
  final String id;
  final String title;

  final String themeColorHex;
  final double progress; // 0.0 to 1.0

  ExamSnapshot({
    required this.id,
    required this.title,
    this.themeColorHex = '#2196F3',
    this.progress = 0.0,
  });

  factory ExamSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ExamSnapshotFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSnapshotToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'subject_snapshot.g.dart';

@JsonSerializable()
class SubjectSnapshot {
  // We keep the ID so we can eventually query the full syllabus
  final String id;
  final String title;
  final String? iconName;
  final String? colorHex;

  SubjectSnapshot({
    required this.id,
    required this.title,
    this.iconName,
    this.colorHex,
  });

  factory SubjectSnapshot.fromJson(Map<String, dynamic> json) =>
      _$SubjectSnapshotFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectSnapshotToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'subject_snapshot.g.dart';

@JsonSerializable()
class SubjectSnapshot {
  final String id;
  final String title;

  SubjectSnapshot({required this.id, required this.title});

  factory SubjectSnapshot.fromJson(Map<String, dynamic> json) =>
      _$SubjectSnapshotFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectSnapshotToJson(this);
}

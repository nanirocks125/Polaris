import 'package:json_annotation/json_annotation.dart';

part 'module_snapshot.g.dart';

@JsonSerializable()
class ModuleSnapshot {
  final String id;
  final String title;
  final int topicsCount; // Essential for the Subject Details list view

  ModuleSnapshot({required this.id, required this.title, this.topicsCount = 0});

  factory ModuleSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ModuleSnapshotFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleSnapshotToJson(this);
}

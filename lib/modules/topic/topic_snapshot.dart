import 'package:json_annotation/json_annotation.dart';

part 'topic_snapshot.g.dart';

@JsonSerializable()
class TopicSnapshot {
  final String id;
  final String title;
  final bool isCompleted; // To show checkmarks in the Module Details list view

  TopicSnapshot({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory TopicSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TopicSnapshotFromJson(json);
  Map<String, dynamic> toJson() => _$TopicSnapshotToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  final String topicId;
  final String title;
  final int totalQuestionsAvailable;

  Topic({
    required this.topicId,
    required this.title,
    this.totalQuestionsAvailable = 0,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicSnapshot _$TopicSnapshotFromJson(Map<String, dynamic> json) =>
    TopicSnapshot(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TopicSnapshotToJson(TopicSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };

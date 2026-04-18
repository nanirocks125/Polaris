// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  description: json['description'] as String,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
  totalTopicsCount: (json['totalTopicsCount'] as num?)?.toInt() ?? 0,
  completedTopicsCount: (json['completedTopicsCount'] as num?)?.toInt() ?? 0,
  topics:
      (json['topics'] as List<dynamic>?)
          ?.map((e) => TopicSnapshot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subject: json['subject'] == null
      ? null
      : SubjectSnapshot.fromJson(json['subject'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'priority': instance.priority,
  'totalTopicsCount': instance.totalTopicsCount,
  'completedTopicsCount': instance.completedTopicsCount,
  'topics': instance.topics,
  'subject': instance.subject,
};

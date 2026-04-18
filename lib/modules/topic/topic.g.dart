// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  isCompleted: json['isCompleted'] as bool? ?? false,
  easeFactor: (json['easeFactor'] as num?)?.toInt() ?? 250,
  isHighYield: json['isHighYield'] as bool? ?? false,
  interval: (json['interval'] as num?)?.toInt() ?? 0,
  repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
  lastReviewedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['lastReviewedAt'],
    const TimestampConverter().fromJson,
  ),
  nextReviewDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['nextReviewDate'],
    const TimestampConverter().fromJson,
  ),
  subject: json['subject'] == null
      ? null
      : SubjectSnapshot.fromJson(json['subject'] as Map<String, dynamic>),
  resourceLinks:
      (json['resourceLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  module: json['module'] == null
      ? null
      : ModuleSnapshot.fromJson(json['module'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'easeFactor': instance.easeFactor,
  'interval': instance.interval,
  'isCompleted': instance.isCompleted,
  'repetitions': instance.repetitions,
  'isHighYield': instance.isHighYield,
  'subject': instance.subject,
  'module': instance.module,
  'lastReviewedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.lastReviewedAt,
    const TimestampConverter().toJson,
  ),
  'nextReviewDate': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.nextReviewDate,
    const TimestampConverter().toJson,
  ),
  'resourceLinks': instance.resourceLinks,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

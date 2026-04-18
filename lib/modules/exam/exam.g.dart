// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  targetDate: const TimestampConverter().fromJson(
    json['targetDate'] as Timestamp,
  ),
  lastStudiedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['lastStudiedAt'],
    const TimestampConverter().fromJson,
  ),
  phases:
      (json['phases'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ExamPhaseEnumMap, e))
          .toList() ??
      const [],
  isActive: json['isActive'] as bool? ?? false,
  targetRecallPercentage:
      (json['targetRecallPercentage'] as num?)?.toInt() ?? 70,
  themeColorHex: json['themeColorHex'] as String? ?? '#2196F3',
  resourceLinks:
      (json['resourceLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  subjects:
      (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectSnapshot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'targetDate': const TimestampConverter().toJson(instance.targetDate),
  'lastStudiedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.lastStudiedAt,
    const TimestampConverter().toJson,
  ),
  'phases': instance.phases.map((e) => _$ExamPhaseEnumMap[e]!).toList(),
  'subjects': instance.subjects,
  'resourceLinks': instance.resourceLinks,
  'isActive': instance.isActive,
  'targetRecallPercentage': instance.targetRecallPercentage,
  'themeColorHex': instance.themeColorHex,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ExamPhaseEnumMap = {
  ExamPhase.prelims: 'prelims',
  ExamPhase.mains: 'mains',
  ExamPhase.interview: 'interview',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

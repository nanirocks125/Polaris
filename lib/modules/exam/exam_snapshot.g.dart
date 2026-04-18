// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSnapshot _$ExamSnapshotFromJson(Map<String, dynamic> json) => ExamSnapshot(
  id: json['id'] as String,
  title: json['title'] as String,
  themeColorHex: json['themeColorHex'] as String? ?? '#2196F3',
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ExamSnapshotToJson(ExamSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'themeColorHex': instance.themeColorHex,
      'progress': instance.progress,
    };

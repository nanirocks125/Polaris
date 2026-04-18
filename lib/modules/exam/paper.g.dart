// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paper _$PaperFromJson(Map<String, dynamic> json) => Paper(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  maxMarks: (json['maxMarks'] as num?)?.toInt() ?? 150,
  order: (json['order'] as num?)?.toInt() ?? 0,
  totalSubjectsCount: (json['totalSubjectsCount'] as num?)?.toInt() ?? 0,
  totalTopicsCount: (json['totalTopicsCount'] as num?)?.toInt() ?? 0,
  completedTopicsCount: (json['completedTopicsCount'] as num?)?.toInt() ?? 0,
  subjects:
      (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectSnapshot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PaperToJson(Paper instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'subjects': instance.subjects.map((e) => e.toJson()).toList(),
  'maxMarks': instance.maxMarks,
  'order': instance.order,
  'totalSubjectsCount': instance.totalSubjectsCount,
  'totalTopicsCount': instance.totalTopicsCount,
  'completedTopicsCount': instance.completedTopicsCount,
};

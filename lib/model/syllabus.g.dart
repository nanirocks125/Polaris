// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syllabus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Syllabus _$SyllabusFromJson(Map<String, dynamic> json) => Syllabus(
  examName: json['examName'] as String,
  subjects: (json['subjects'] as List<dynamic>)
      .map((e) => Subject.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SyllabusToJson(Syllabus instance) => <String, dynamic>{
  'examName': instance.examName,
  'subjects': instance.subjects.map((e) => e.toJson()).toList(),
};

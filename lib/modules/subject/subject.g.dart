// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
  title: json['title'] as String,
  iconName: json['iconName'] as String?,
  description: json['description'] as String? ?? '',
  isGeneralStudies: json['isGeneralStudies'] as bool? ?? true,
);

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
  'title': instance.title,
  'iconName': instance.iconName,
  'description': instance.description,
  'isGeneralStudies': instance.isGeneralStudies,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  iconName: json['iconName'] as String?,
  description: json['description'] as String? ?? '',
  isGeneralStudies: json['isGeneralStudies'] as bool? ?? true,
  modulesCount: (json['modulesCount'] as num?)?.toInt() ?? 0,
  completedModulesCount: (json['completedModulesCount'] as num?)?.toInt() ?? 0,
  totalTopicsCount: (json['totalTopicsCount'] as num?)?.toInt() ?? 0,
  completedTopicsCount: (json['completedTopicsCount'] as num?)?.toInt() ?? 0,
  modules:
      (json['modules'] as List<dynamic>?)
          ?.map((e) => ModuleSnapshot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'iconName': instance.iconName,
  'description': instance.description,
  'modulesCount': instance.modulesCount,
  'completedModulesCount': instance.completedModulesCount,
  'totalTopicsCount': instance.totalTopicsCount,
  'completedTopicsCount': instance.completedTopicsCount,
  'modules': instance.modules.map((e) => e.toJson()).toList(),
  'isGeneralStudies': instance.isGeneralStudies,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
  title: json['title'] as String,
  description: json['description'] as String,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'priority': instance.priority,
};

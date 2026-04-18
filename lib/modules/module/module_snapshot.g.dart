// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleSnapshot _$ModuleSnapshotFromJson(Map<String, dynamic> json) =>
    ModuleSnapshot(
      id: json['id'] as String,
      title: json['title'] as String,
      topicsCount: (json['topicsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ModuleSnapshotToJson(ModuleSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'topicsCount': instance.topicsCount,
    };

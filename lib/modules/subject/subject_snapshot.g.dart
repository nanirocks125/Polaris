// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectSnapshot _$SubjectSnapshotFromJson(Map<String, dynamic> json) =>
    SubjectSnapshot(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String?,
      colorHex: json['colorHex'] as String?,
    );

Map<String, dynamic> _$SubjectSnapshotToJson(SubjectSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
    };

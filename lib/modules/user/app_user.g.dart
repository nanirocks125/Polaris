// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  name: json['name'] as String?,
  email: json['email'] as String?,
  activeExamId: json['activeExamId'] as String?,
  assignedExams:
      (json['assignedExams'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  role: $enumDecodeNullable(_$AppUserRoleEnumMap, json['role']) ?? .user,
  settings: json['settings'] == null
      ? null
      : AppUserSettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'role': _$AppUserRoleEnumMap[instance.role]!,
  'activeExamId': instance.activeExamId,
  'assignedExams': instance.assignedExams,
  'settings': instance.settings,
};

const _$AppUserRoleEnumMap = {
  AppUserRole.admin: 'admin',
  AppUserRole.user: 'user',
};

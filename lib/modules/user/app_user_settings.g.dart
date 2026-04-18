// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserSettings _$AppUserSettingsFromJson(Map<String, dynamic> json) =>
    AppUserSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      enablePushNotifications: json['enablePushNotifications'] as bool? ?? true,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
    );

Map<String, dynamic> _$AppUserSettingsToJson(AppUserSettings instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'enablePushNotifications': instance.enablePushNotifications,
      'preferredLanguage': instance.preferredLanguage,
    };

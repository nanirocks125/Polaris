import 'package:json_annotation/json_annotation.dart';

part 'app_user_settings.g.dart';

@JsonSerializable()
class AppUserSettings {
  bool isDarkMode;
  bool enablePushNotifications;
  String preferredLanguage; // 'en' or 'te' for your bilingual flow

  AppUserSettings({
    this.isDarkMode = false,
    this.enablePushNotifications = true,
    this.preferredLanguage = 'en',
  });

  factory AppUserSettings.fromJson(Map<String, dynamic> json) =>
      _$AppUserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserSettingsToJson(this);
}

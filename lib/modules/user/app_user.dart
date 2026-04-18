import 'package:json_annotation/json_annotation.dart';
import 'package:polaris/modules/user/app_user_role.dart';
import 'package:polaris/modules/user/app_user_settings.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  @JsonKey(includeToJson: false, includeFromJson: false)
  String id;

  String? name;
  String? email;
  AppUserRole role;

  // The Switchboard
  String? activeExamId;
  List<String> assignedExams;

  // Nested Settings for cleaner state management
  AppUserSettings settings;

  AppUser({
    this.id = '',
    this.name,
    this.email,
    this.activeExamId,
    this.assignedExams = const [],
    this.role = .user,
    AppUserSettings? settings,
  }) : settings = settings ?? AppUserSettings();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

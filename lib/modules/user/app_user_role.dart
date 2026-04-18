import 'package:json_annotation/json_annotation.dart';

enum AppUserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('user')
  user,
}

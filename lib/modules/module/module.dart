import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String id;

  String title;
  String description;
  int priority; // To keep "Basics" before "Advanced"

  Module({
    this.id = '',
    required this.title,
    required this.description,
    this.priority = 0,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  factory Module.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception("Module data null");
    final module = Module.fromJson(data);
    module.id = doc.id;
    return module;
  }
}

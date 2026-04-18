import 'package:json_annotation/json_annotation.dart';

enum ExamPhase {
  @JsonValue('prelims')
  prelims,
  @JsonValue('mains')
  mains,
  @JsonValue('interview')
  interview,
}

// Helper to make enum names pretty
extension ExamPhaseExtension on ExamPhase {
  String get label {
    switch (this) {
      case ExamPhase.prelims:
        return 'Prelims';
      case ExamPhase.mains:
        return 'Mains';
      case ExamPhase.interview:
        return 'Interview';
    }
  }
}

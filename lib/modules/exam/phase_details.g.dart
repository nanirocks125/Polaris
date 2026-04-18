// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhaseDetail _$PhaseDetailFromJson(Map<String, dynamic> json) => PhaseDetail(
  phase: $enumDecode(_$ExamPhaseEnumMap, json['phase']),
  totalMarks: (json['totalMarks'] as num?)?.toInt() ?? 0,
  previousCutoff: (json['previousCutoff'] as num?)?.toDouble(),
  papers:
      (json['papers'] as List<dynamic>?)
          ?.map((e) => Paper.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PhaseDetailToJson(PhaseDetail instance) =>
    <String, dynamic>{
      'phase': _$ExamPhaseEnumMap[instance.phase]!,
      'totalMarks': instance.totalMarks,
      'previousCutoff': instance.previousCutoff,
      'papers': instance.papers.map((e) => e.toJson()).toList(),
    };

const _$ExamPhaseEnumMap = {
  ExamPhase.prelims: 'prelims',
  ExamPhase.mains: 'mains',
  ExamPhase.interview: 'interview',
};

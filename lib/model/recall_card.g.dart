// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recall_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecallCard _$RecallCardFromJson(Map<String, dynamic> json) => RecallCard(
  id: json['id'] as String,
  subject: json['subject'] as String,
  topic: json['topic'] as String,
  question: json['question'] as String,
  answer: json['answer'] as String,
  nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
  interval: (json['interval'] as num?)?.toInt() ?? 0,
  easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
);

Map<String, dynamic> _$RecallCardToJson(RecallCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'topic': instance.topic,
      'question': instance.question,
      'answer': instance.answer,
      'nextReviewDate': instance.nextReviewDate.toIso8601String(),
      'interval': instance.interval,
      'easeFactor': instance.easeFactor,
    };

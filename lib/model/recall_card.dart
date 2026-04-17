import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// This tells the generator to create this file
part 'recall_card.g.dart';

@JsonSerializable()
class RecallCard {
  String id;
  String subject;
  String topic;
  String question;
  String answer;
  DateTime nextReviewDate;
  int interval; // Days until next review
  double easeFactor; // Multiplier for how easy the card is

  RecallCard({
    required this.id,
    required this.subject,
    required this.topic,
    required this.question,
    required this.answer,
    required this.nextReviewDate,
    this.interval = 0,
    this.easeFactor = 2.5,
  });

  // The auto-generated JSON parsing methods
  factory RecallCard.fromJson(Map<String, dynamic> json) =>
      _$RecallCardFromJson(json);
  Map<String, dynamic> toJson() => _$RecallCardToJson(this);

  // Helper factory to parse directly from Firestore
  // Helper factory to parse directly from Firestore
  factory RecallCard.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    // Safety check to satisfy the null-safety analyzer
    if (data == null) {
      throw Exception("Document data was null for ID: ${doc.id}");
    }

    final card = RecallCard.fromJson(data);
    card.id = doc.id; // Inject the document ID here
    return card;
  }
}

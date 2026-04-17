import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polaris/model/recall_card.dart';

class RecallService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper getter to find the current user's document path
  String? get _uid => _auth.currentUser?.uid;

  /// Retrieves the stream of cards that are due for review today or earlier.
  Stream<List<RecallCard>> getDueCardsStream() {
    if (_uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(_uid)
        .collection('cards')
        .where('nextReviewDate', isLessThanOrEqualTo: Timestamp.now())
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecallCard.fromFirestore(doc))
              .toList(),
        );
  }

  /// Calculates the Spaced Repetition math and updates the card in Firestore.
  /// Score scale: 0 (Fail), 1 (Hard), 2 (Good), 3 (Easy)
  Future<void> gradeAndSaveCard(RecallCard card, int score) async {
    if (_uid == null) throw Exception("User not authenticated");

    // 1. Calculate the new values based on the score
    if (score == 0) {
      // Failed. Reset interval, penalize ease factor.
      card.interval = 0;
      card.easeFactor = (card.easeFactor - 0.2).clamp(1.3, 2.5);
    } else {
      // Passed. Determine new interval.
      if (card.interval == 0) {
        card.interval = 1; // See it tomorrow
      } else if (card.interval == 1) {
        card.interval = 3; // Jump to 3 days
      } else {
        // Standard SRS Math
        double multiplier = score == 3 ? 1.3 : 1.0; // Bonus for 'Easy'
        card.interval = (card.interval * card.easeFactor * multiplier).round();
      }

      // Adjust ease factor based on performance
      if (score == 1) {
        card.easeFactor = (card.easeFactor - 0.15).clamp(1.3, 2.5);
      } else if (score == 3) {
        card.easeFactor = (card.easeFactor + 0.15).clamp(1.3, 2.5);
      }
    }

    // 2. Set the exact next review date
    card.nextReviewDate = DateTime.now().add(Duration(days: card.interval));

    // 3. Update the specific document in Firestore using toJson()
    await _db
        .collection('users')
        .doc(_uid)
        .collection('cards')
        .doc(card.id)
        .update(card.toJson());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managestudents/models/test_data.dart';

class TestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTest(String classId, String title, String deckId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    final testId = _firestore.collection('tests').doc().id;
    await _firestore.collection('tests').doc(testId).set({
      'teacherId': userId,
      'classId': classId,
      'title': title,
      'deckId': deckId,
    });
  }

  Future<List<Test>> getTests() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    final querySnapshot = await _firestore
        .collection('tests')
        .where('teacherId', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => Test.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}

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
    final testId = _firestore
        .collection('tests')
        .doc(classId)
        .collection('assignments')
        .doc()
        .id;

    // Add teacherId to the tests collection document
    await _firestore.collection('tests').doc(classId).set({
      'teacherId': userId,
    }, SetOptions(merge: true));

    // Add the assignment to the assignments subcollection
    await _firestore
        .collection('tests')
        .doc(classId)
        .collection('assignments')
        .doc(testId)
        .set({
      'title': title,
      'deckId': deckId,
    });
  }

  Future<List<Test>> getTests() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // 1) Find all class documents in /tests that belong to the current teacher
    final classSnapshot = await _firestore
        .collection('tests')
        .where('teacherId', isEqualTo: userId)
        .get();

    // Initialize an empty list to accumulate all Test objects
    List<Test> allTests = [];

    // 2) For each class doc, fetch docs in its `assignments` subcollection
    for (var classDoc in classSnapshot.docs) {
      final assignmentsSnapshot =
          await classDoc.reference.collection('assignments').get();

      final tests = assignmentsSnapshot.docs.map((assignmentDoc) {
        return Test.fromFirestore(
          assignmentDoc.id,
          assignmentDoc.data() as Map<String, dynamic>,
        );
      }).toList();

      // Add the fetched tests to the allTests list
      allTests.addAll(tests);
    }

    return allTests;
  }
}

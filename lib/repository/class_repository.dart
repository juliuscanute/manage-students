import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managestudents/models/class_data.dart';

class ClassRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Class>> getClasses() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Class.fromDocument(doc)).toList();
    });
  }

  Future<void> addClass(Class newClass) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .add(newClass.toMap());
  }

  Future<void> updateClass(Class updatedClass) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(updatedClass.id)
        .update(updatedClass.toMap());
  }

  Future<void> deleteClass(String classId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(classId)
        .delete();
  }
}

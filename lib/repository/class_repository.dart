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

  Future<void> addClass(Class newClass) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    final classDocRef = await _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .add(newClass.toMap());

    await _associateClassWithStudents(newClass.studentIds, classDocRef.id);
  }

  Future<void> updateClass(Class updatedClass) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get the previous class data
    final classDoc = await _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(updatedClass.id)
        .get();

    if (classDoc.exists) {
      final previousClass = Class.fromDocument(classDoc);

      // Remove classId from students no longer associated with the class
      final removedStudentIds = previousClass.studentIds
          .where((id) => !updatedClass.studentIds.contains(id))
          .toList();
      await _disassociateClassFromStudents(removedStudentIds, updatedClass.id);
    }

    await _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(updatedClass.id)
        .update(updatedClass.toMap());

    // Add classId to newly associated students
    await _associateClassWithStudents(updatedClass.studentIds, updatedClass.id);
  }

  Future<void> deleteClass(String classId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get the class data before deleting
    final classDoc = await _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(classId)
        .get();

    if (classDoc.exists) {
      final classData = Class.fromDocument(classDoc);
      await _disassociateClassFromStudents(classData.studentIds, classId);
    }

    return _firestore
        .collection('classes')
        .doc(userId)
        .collection('sections')
        .doc(classId)
        .delete();
  }

  Future<void> _associateClassWithStudents(
      List<String> studentIds, String classId) async {
    final batch = _firestore.batch();

    for (final studentId in studentIds) {
      final querySnapshot = await _firestore
          .collection('studentCodes')
          .where('studentId', isEqualTo: studentId)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'classId': classId});
      }
    }

    await batch.commit();
  }

  Future<void> _disassociateClassFromStudents(
      List<String> studentIds, String classId) async {
    final batch = _firestore.batch();

    for (final studentId in studentIds) {
      final querySnapshot = await _firestore
          .collection('studentCodes')
          .where('studentId', isEqualTo: studentId)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'classId': FieldValue.delete()});
      }
    }

    await batch.commit();
  }
}

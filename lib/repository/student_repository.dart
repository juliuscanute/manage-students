import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managestudents/models/student_data.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Student>> getStudents() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Student.fromDocument(doc)).toList();
    });
  }

  Future<void> addStudent(Student newStudent) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .add(newStudent.toMap());
  }

  Future<void> deleteStudent(String studentId) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(studentId)
        .delete();
  }

  Future<void> updateStudent(Student updatedStudent) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(updatedStudent.id)
        .update(updatedStudent.toMap());
  }
}

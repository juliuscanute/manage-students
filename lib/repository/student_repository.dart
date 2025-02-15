import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managestudents/models/student_data.dart';
import 'package:managestudents/utils/utility.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _generateUniqueCode() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    for (int i = 0; i < 3; i++) {
      final code = generateCode();
      final existingCode =
          await _firestore.collection('studentCodes').doc(code).get();

      if (!existingCode.exists) {
        return code;
      }
    }

    throw Exception('Failed to generate a unique code');
  }

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

  Future<void> addStudent(Student newStudent) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    final code = await _generateUniqueCode();
    final studentWithCode = newStudent.copyWith(code: code);

    final docRef = await _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .add(studentWithCode.toMap());

    await _firestore
        .collection('studentCodes')
        .doc(code)
        .set({'studentId': docRef.id});
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    await _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(updatedStudent.id)
        .update(updatedStudent.toMap());
  }

  Future<String> rotateStudentCode(String studentId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    final studentDoc = await _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(studentId)
        .get();

    if (!studentDoc.exists) {
      throw Exception('Student not found');
    }

    final student = Student.fromDocument(studentDoc);
    final newCode = await _generateUniqueCode();

    await _firestore.collection('studentCodes').doc(student.code).delete();

    await _firestore
        .collection('studentCodes')
        .doc(newCode)
        .set({'studentId': student.id});

    final updatedStudent = student.copyWith(code: newCode);
    await updateStudent(updatedStudent);
    return newCode;
  }

  Future<void> deleteStudent(String studentId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    final studentDoc = await _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(studentId)
        .get();

    if (!studentDoc.exists) {
      throw Exception('Student not found');
    }

    final student = Student.fromDocument(studentDoc);

    await _firestore
        .collection('students')
        .doc(user.uid)
        .collection('sections')
        .doc(studentId)
        .delete();

    await _firestore.collection('studentCodes').doc(student.code).delete();
  }
}

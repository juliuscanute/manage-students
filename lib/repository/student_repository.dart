import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managestudents/models/student_data.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Student>> getStudents() {
    return _firestore.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Student.fromDocument(doc)).toList();
    });
  }

  Future<void> addStudent(Student newStudent) {
    return _firestore.collection('students').add(newStudent.toMap());
  }

  Future<void> deleteStudent(String studentId) {
    return _firestore.collection('students').doc(studentId).delete();
  }
}

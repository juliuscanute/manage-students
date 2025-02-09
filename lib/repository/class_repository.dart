import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managestudents/models/class_data.dart';

class ClassRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Class>> getClasses() {
    return _firestore.collection('classes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Class.fromDocument(doc)).toList();
    });
  }

  Future<void> addClass(Class newClass) {
    return _firestore.collection('classes').add(newClass.toMap());
  }

  Future<void> updateClass(Class updatedClass) {
    return _firestore
        .collection('classes')
        .doc(updatedClass.id)
        .update(updatedClass.toMap());
  }

  Future<void> deleteClass(String classId) {
    return _firestore.collection('classes').doc(classId).delete();
  }
}

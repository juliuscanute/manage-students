import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;

  Student({required this.id, required this.name});

  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc.id,
      name: doc['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

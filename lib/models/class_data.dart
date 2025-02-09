import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  final String id;
  final String name;
  final List<String> studentIds;

  Class({required this.id, required this.name, this.studentIds = const []});

  factory Class.fromDocument(DocumentSnapshot doc) {
    return Class(
      id: doc.id,
      name: doc['name'],
      studentIds: List<String>.from(doc['studentIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentIds': studentIds,
    };
  }
}

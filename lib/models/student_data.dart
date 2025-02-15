import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String code;

  Student({required this.id, required this.name, required this.code});

  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc.id,
      name: doc['name'],
      code: doc['code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
    };
  }

  Student copyWith({String? id, String? name, String? code}) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }
}

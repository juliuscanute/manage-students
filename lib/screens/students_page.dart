// create_student_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/models/student_data.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  State<CreateStudentPage> createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addStudent() {
    final studentName = _nameController.text;
    if (studentName.isNotEmpty) {
      final newStudent = Student(
        id: DateTime.now().toString(),
        name: studentName,
      );
      context.read<StudentCubit>().addStudent(newStudent);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

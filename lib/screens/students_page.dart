import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/models/student_data.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({Key? key, this.student}) : super(key: key);

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  late TextEditingController _nameController;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      // Existing student
      _nameController = TextEditingController(text: widget.student?.name ?? '');
      _isEditing = true;
    } else {
      // New student
      _nameController = TextEditingController();
      _isEditing = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    final studentName = _nameController.text;
    if (studentName.isNotEmpty) {
      if (!_isEditing) {
        final newStudent = Student(
          id: DateTime.now().toString(),
          name: studentName,
        );
        context.read<StudentCubit>().addStudent(newStudent);
      } else {
        final updatedStudent = Student(
          id: widget.student!.id,
          name: studentName,
        );
        context.read<StudentCubit>().updateStudent(updatedStudent);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Student' : 'Create Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStudent,
              child: Text(_isEditing ? 'Update Student' : 'Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/models/student_data.dart';
import 'package:managestudents/utils/utility.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({Key? key, this.student}) : super(key: key);

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  late TextEditingController _nameController;
  late bool _isEditing;
  late String _studentCode;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      // Existing student
      _nameController = TextEditingController(text: widget.student?.name ?? '');
      _isEditing = true;
      _studentCode = widget.student?.code ?? '';
    } else {
      // New student
      _nameController = TextEditingController();
      _isEditing = false;
      _studentCode = '';
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
          code: _studentCode,
        );
        context.read<StudentCubit>().addStudent(newStudent);
      } else {
        final updatedStudent = Student(
          id: widget.student!.id,
          name: studentName,
          code: _studentCode,
        );
        context.read<StudentCubit>().updateStudent(updatedStudent);
      }
      Navigator.of(context).pop();
    }
  }

  void _rotateCode() async {
    if (_isEditing) {
      final code = await context
          .read<StudentCubit>()
          .rotateStudentCode(widget.student!.id);
      setState(() {
        _studentCode = code;
      });
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _studentCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Student' : 'Create Student'),
      ),
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
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
                if (_isEditing)
                  Row(
                    children: [
                      Text('Code: $_studentCode'),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _rotateCode,
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: _copyCode,
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text(_isEditing ? 'Update Student' : 'Add Student'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

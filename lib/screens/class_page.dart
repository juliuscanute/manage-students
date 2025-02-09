// create_class_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/models/student_data.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({Key? key}) : super(key: key);

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final TextEditingController _nameController = TextEditingController();
  final Set<String> _selectedStudentIds = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addClass() {
    final className = _nameController.text;
    if (className.isNotEmpty) {
      final newClass = Class(
        id: DateTime.now().toString(),
        name: className,
        studentIds: _selectedStudentIds.toList(),
      );
      context.read<ClassCubit>().addClass(newClass);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Class name input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Class Name'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Associate Students:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // List of students with checkboxes
            Expanded(
              child: BlocBuilder<StudentCubit, List<Student>>(
                builder: (context, students) {
                  if (students.isEmpty) {
                    return const Center(
                      child: Text('No students available for association.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return CheckboxListTile(
                        title: Text(student.name),
                        value: _selectedStudentIds.contains(student.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedStudentIds.add(student.id);
                            } else {
                              _selectedStudentIds.remove(student.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addClass,
              child: const Text('Add Class'),
            ),
          ],
        ),
      ),
    );
  }
}

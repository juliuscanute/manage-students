import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/models/student_data.dart';

class ClassFormPage extends StatefulWidget {
  final Class? classItem;

  const ClassFormPage({Key? key, this.classItem}) : super(key: key);

  @override
  State<ClassFormPage> createState() => _ClassFormPageState();
}

class _ClassFormPageState extends State<ClassFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final Set<String> _selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.classItem != null) {
      _nameController.text = widget.classItem!.name;
      _selectedStudentIds.addAll(widget.classItem!.studentIds);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveClass() {
    final className = _nameController.text;
    if (className.isNotEmpty) {
      final classItem = Class(
        id: widget.classItem?.id ?? DateTime.now().toString(),
        name: className,
        studentIds: _selectedStudentIds.toList(),
      );
      if (widget.classItem == null) {
        context.read<ClassCubit>().addClass(classItem);
      } else {
        context.read<ClassCubit>().updateClass(classItem);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classItem == null ? 'Create Class' : 'Edit Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Class name input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Class Name',
                border: OutlineInputBorder(),
              ),
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
              onPressed: _saveClass,
              child:
                  Text(widget.classItem == null ? 'Add Class' : 'Save Class'),
            ),
          ],
        ),
      ),
    );
  }
}

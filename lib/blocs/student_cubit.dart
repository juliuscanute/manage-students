import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/models/student_data.dart';
import 'package:managestudents/repository/student_repository.dart';

class StudentCubit extends Cubit<List<Student>> {
  final StudentRepository _studentRepository;

  StudentCubit(this._studentRepository) : super([]) {
    _studentRepository.getStudents().listen((students) {
      emit(students);
    });
  }

  Future<void> addStudent(Student newStudent) async {
    await _studentRepository.addStudent(newStudent);
  }

  Future<void> deleteStudent(String studentId) async {
    await _studentRepository.deleteStudent(studentId);
  }

  Future<void> updateStudent(Student updatedStudent) async {
    await _studentRepository.updateStudent(updatedStudent);
  }
}

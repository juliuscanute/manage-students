import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/models/student_data.dart';
import 'package:managestudents/repository/student_repository.dart';

class StudentState {
  final List<Student> students;
  final bool isLoading;

  StudentState({required this.students, required this.isLoading});
}

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _studentRepository;

  StudentCubit(this._studentRepository)
      : super(StudentState(students: [], isLoading: false)) {
    _studentRepository.getStudents().listen((students) {
      emit(StudentState(students: students, isLoading: false));
    });
  }

  Future<void> addStudent(Student newStudent) async {
    emit(StudentState(students: state.students, isLoading: true));
    await _studentRepository.addStudent(newStudent);
    emit(StudentState(students: state.students, isLoading: false));
  }

  Future<void> updateStudent(Student updatedStudent) async {
    emit(StudentState(students: state.students, isLoading: true));
    await _studentRepository.updateStudent(updatedStudent);
    emit(StudentState(students: state.students, isLoading: false));
  }

  Future<String> rotateStudentCode(String studentId) async {
    emit(StudentState(students: state.students, isLoading: true));
    final code = await _studentRepository.rotateStudentCode(studentId);
    emit(StudentState(students: state.students, isLoading: false));
    return code;
  }

  Future<void> deleteStudent(String studentId) async {
    emit(StudentState(students: state.students, isLoading: true));
    await _studentRepository.deleteStudent(studentId);
    emit(StudentState(students: state.students, isLoading: false));
  }
}

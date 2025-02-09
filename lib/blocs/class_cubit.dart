import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/repository/class_repository.dart';

class ClassCubit extends Cubit<List<Class>> {
  final ClassRepository _classRepository;

  ClassCubit(this._classRepository) : super([]) {
    _classRepository.getClasses().listen((classes) {
      emit(classes);
    });
  }

  Future<void> addClass(Class newClass) async {
    await _classRepository.addClass(newClass);
  }

  Future<void> updateClass(Class updatedClass) async {
    await _classRepository.updateClass(updatedClass);
  }

  Future<void> deleteClass(String classId) async {
    await _classRepository.deleteClass(classId);
  }
}

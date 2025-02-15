import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/repository/class_repository.dart';

class ClassState {
  final List<Class> classes;
  final bool isLoading;

  ClassState({required this.classes, required this.isLoading});
}

class ClassCubit extends Cubit<ClassState> {
  final ClassRepository _classRepository;

  ClassCubit(this._classRepository)
      : super(ClassState(classes: [], isLoading: false)) {
    _classRepository.getClasses().listen((classes) {
      emit(ClassState(classes: classes, isLoading: false));
    });
  }

  Future<void> addClass(Class newClass) async {
    emit(ClassState(classes: state.classes, isLoading: true));
    await _classRepository.addClass(newClass);
    emit(ClassState(classes: state.classes, isLoading: false));
  }

  Future<void> updateClass(Class updatedClass) async {
    emit(ClassState(classes: state.classes, isLoading: true));
    await _classRepository.updateClass(updatedClass);
    emit(ClassState(classes: state.classes, isLoading: false));
  }

  Future<void> deleteClass(String classId) async {
    emit(ClassState(classes: state.classes, isLoading: true));
    await _classRepository.deleteClass(classId);
    emit(ClassState(classes: state.classes, isLoading: false));
  }
}

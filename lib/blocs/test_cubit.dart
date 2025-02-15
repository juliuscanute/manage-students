import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/repository/test_repository.dart';

class TestCubit extends Cubit<void> {
  final TestRepository _testRepository;

  TestCubit(this._testRepository) : super(null);

  Future<void> addTest(String classId, String title, String deckId) async {
    await _testRepository.addTest(classId, title, deckId);
  }
}

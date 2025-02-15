import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/models/test_data.dart';
import 'package:managestudents/repository/test_repository.dart';

class TestCubit extends Cubit<List<Test>> {
  final TestRepository _testRepository;

  TestCubit(this._testRepository) : super([]);

  Future<void> fetchTests() async {
    final tests = await _testRepository.getTests();
    emit(tests);
  }

  Future<void> addTest(String classId, String title, String deckId) async {
    await _testRepository.addTest(classId, title, deckId);
    await fetchTests(); // Refresh the list of tests after adding a new test
  }
}

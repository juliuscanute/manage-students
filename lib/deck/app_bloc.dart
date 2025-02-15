import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/deck/firebase_service.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppCubit extends Bloc<AppEvent, AppState> {
  final FirebaseService firebaseService;

  AppCubit(this.firebaseService) : super(AppInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<RefreshCategories>(_onRefreshCategories);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final categories = await firebaseService.getSubFolders(event.parentPath);
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(AppError('Error loading categories'));
    }
  }

  Future<void> _onRefreshCategories(
      RefreshCategories event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final categories = await firebaseService.getSubFolders(event.parentPath);
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(AppError('Error refreshing categories'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/login_repository.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;

  LoginCubit(this._loginRepository) : super(LoginState());

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _loginRepository.signIn(email, password);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}

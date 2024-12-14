import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/login/login_state.dart';

import '../../services/user_services.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;

  LoginBloc({required this.userService}) : super(LoginInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmittedEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoadingState());

    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const LoginFailureState('Please enter both email and password'));
        return;
      }

      final user = await userService.login(
        event.email.trim(),
        event.password.trim(),
      );

      if (user != null) {
        emit(LoginSuccessState(user: user));
      } else {
        emit(const LoginFailureState('Login Failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(LoginFailureState('An error occurred: ${e.toString()}'));
    }
  }
}
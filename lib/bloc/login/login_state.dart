import '../../models/user.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitialState extends LoginState{}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;
  LoginSuccessState({required this.user});
}

class LoginFailureState extends LoginState {
  final String error;
  const LoginFailureState(this.error);
}

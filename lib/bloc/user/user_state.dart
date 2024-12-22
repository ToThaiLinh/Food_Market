import '../../models/user.dart';

abstract class UserState {
  const UserState();
}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final User user;
  const UserLoadedState(this.user);
}

class UserErrorState extends UserState{
  final String message;
  const UserErrorState(this.message);
}
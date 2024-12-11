import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/user_event.dart';
import 'package:food/bloc/user/user_state.dart';

import '../../services/user_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitialState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
    on<UpdateUserInfoEvent>(_onUpdateUserInfo);
  }

  Future<void> _onLoadUserInfo(LoadUserInfoEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final user = await userService.getUserInfo();
      emit(UserLoadedState(user));
    } catch(e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateUserInfo(UpdateUserInfoEvent event, Emitter<UserState> emit) async {
    try {
      await userService.updateUserInfo(event.updateData);
      add(LoadUserInfoEvent());
    }
    catch(e) {
      emit(UserErrorState(e.toString()));
    }
}
}
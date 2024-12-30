import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/group.dart';
import '../../services/group_service.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupService groupService;

  GroupBloc({required this.groupService}) : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());
      try {
        final response = await groupService.getAllGroupByUserId();

        final groups = (response['groups'] as List)
            .map((item) => Group.fromJson(item))
            .toList();
        emit(GroupLoaded(groups));
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });

    on<CreateGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        final response = await groupService.createGroup(event.name);
        final newGroup = Group.fromJson(response);
        final currentState = state;

        if (currentState is GroupLoaded) {
          emit(GroupLoaded([...currentState.groups, newGroup]));
        } else {
          emit(GroupLoaded([newGroup]));
        }
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });

    on<DeleteGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        //await groupService.deleteGroup(event.id);
        final currentState = state;

        if (currentState is GroupLoaded) {
          final updatedGroups = currentState.groups
              .where((group) => group.id != event.id)
              .toList();
          emit(GroupLoaded(updatedGroups));
        }
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });
  }
}
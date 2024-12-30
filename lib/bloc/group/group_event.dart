// Events
import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupEvent {}

class CreateGroup extends GroupEvent {
  final String name;
  const CreateGroup(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteGroup extends GroupEvent {
  final String id;
  const DeleteGroup(this.id);

  @override
  List<Object?> get props => [id];
}

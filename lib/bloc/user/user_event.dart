abstract class UserEvent {
  const UserEvent();
}

class LoadUserInfoEvent extends UserEvent {}

class UpdateUserInfoEvent extends UserEvent {
  final Map<String, dynamic> updateData;

  const UpdateUserInfoEvent(this.updateData);
}
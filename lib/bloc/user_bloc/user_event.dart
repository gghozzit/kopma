part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetMyUser extends UserEvent {
  final String myUserId;

  const GetMyUser({required this.myUserId});

  @override
  List<Object> get props => [myUserId];
}

class SetUserData extends UserEvent {
  final UserModel user;

  const SetUserData({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteMyUser extends UserEvent {
  final String myUserId;

  const DeleteMyUser({required this.myUserId});

  @override
  List<Object> get props => [myUserId];
}
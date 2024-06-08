part of 'user_bloc.dart';

enum UserStatus { success, loading, failure, isDeleted }

class UserState extends Equatable {

  final UserStatus status;
  final UserModel? user;
  final bool? isDeleted;

  const UserState._({
    this.status = UserStatus.loading,
    this.user,
    this.isDeleted
  });

  const UserState.loading() : this._();

  const UserState.success(UserModel user) : this._(status: UserStatus.success, user: user);

  const UserState.isDeleted(bool isDeleted) : this._(status: UserStatus.isDeleted, isDeleted: isDeleted);

  const UserState.failure() : this._(status: UserStatus.failure);

  @override
  List<Object?> get props => [status, user];
}
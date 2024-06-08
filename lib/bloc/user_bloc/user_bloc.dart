import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kopma/data/model/user/user_model.dart';
import '../../data/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try {
        UserModel myUser = await userRepository.getMyUser(event.myUserId);
        emit(UserState.success(myUser));
      } catch (e) {
        log(e.toString());
        emit(const UserState.failure());
      }
    });

    on<SetUserData>((event, emit) async {
      try {
        await userRepository.setUserData(event.user);
        emit(UserState.success(event.user));
      } catch (e) {
        log(e.toString());
        emit(const UserState.failure());
      }
    });

    on<DeleteMyUser>((event, emit) async {
      try {
        emit(const UserState.isDeleted(false));
        bool isDeleted = await userRepository.deleteMyUser(event.myUserId);
        emit(UserState.isDeleted(isDeleted));
      } catch (e) {
        log(e.toString());
        emit(const UserState.failure());
      }
    });
  }
}
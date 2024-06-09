import 'package:kopma/data/model/user/user_model.dart';

abstract class UserRepository {
  Future<void> setUserData(UserModel user);
  Future<UserModel> getMyUser(String myUserId);
  Future<bool> deleteMyUser(String myUserId);
}
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopma/data/model/user/user_entity.dart';
import 'package:kopma/data/model/user/user_model.dart';
import 'package:kopma/data/user_repository.dart';
import '../../../di/service_locator.dart';
import '../shared_preferences_service.dart';

class FirebaseUserDataSource implements UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final sharedPrefService = serviceLocator<SharedPreferencesService>();

  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> getMyUser(String myUserId) async {
    try {
      return await usersCollection
          .doc(myUserId)
          .get()
          .whenComplete(() => {
        if(sharedPrefService.uid.isEmpty) sharedPrefService.uid = myUserId
      }).then((value) => UserModel.fromEntity(UserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> deleteMyUser(String myUserId) async {
    try {
      bool isDeleted = false;
      await usersCollection
          .doc(myUserId)
          .delete()
          .whenComplete(() => isDeleted = true);
      return isDeleted;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

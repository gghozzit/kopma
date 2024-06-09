import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopma/data/model/item/item_entity.dart';
import 'package:kopma/data/model/item/item_model.dart';
import '../../../di/service_locator.dart';
import '../shared_preferences_service.dart';

class FirebaseTranscationDataSource {
  final transactionCollection = FirebaseFirestore.instance.collection('transaction');
  final sharedPrefService = serviceLocator<SharedPreferencesService>();

  Query<Map<String, dynamic>> getListTransaction(String? query) {
    try {
      return transactionCollection.orderBy('dateTime', descending: true);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}

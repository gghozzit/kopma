import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopma/data/model/item/item_model.dart';
import 'datasource/local/local_cart_datasource.dart';
import 'datasource/network/firebase_item_datasource.dart';
import 'item_repository.dart';


class ItemRepositoryImpl implements ItemRepository {
  final FirebaseItemDataSource _firebaseItemDataSource;
  final LocalCartDataSource _localCartDataSource;


  ItemRepositoryImpl(this._firebaseItemDataSource, this._localCartDataSource);


  @override
  Future<bool> postItem(ItemModel item) async {
    try {
      return await _firebaseItemDataSource.postItem(item);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<String> uploadImage(File file, String fileName) async {
    try {
      return await _firebaseItemDataSource.uploadImage(file, fileName);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<bool> buyItem(String itemId, int quantity) async {
    try {
      return await _firebaseItemDataSource.buyItem(itemId, quantity);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<bool> deleteItem(String itemId) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }


  @override
  Future<ItemModel> getDetailItem(String id) async {
    try {
      return await _firebaseItemDataSource.getDetailItem(id);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Query<Map<String, dynamic>> getListItem(String? query) {
    try {
      return _firebaseItemDataSource.getListItem(query);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }



  @override
  Future<List<ItemModel>> getListItemFromCart() async {
    try {
      return await _localCartDataSource.getListItemFromCart();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<bool> addItemToCart(ItemModel item) async {
    try {
      return await _localCartDataSource.addItemToCart(item);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<bool> buyItemFromCart(String itemId, int quantity) async {
    try {
      return await _firebaseItemDataSource
          .buyItem(itemId, quantity)
          .whenComplete(() => deleteItemFromCart(itemId));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<bool> deleteItemFromCart(String itemId) async {
    try {
      return await _localCartDataSource.deleteItemFromCart(itemId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}



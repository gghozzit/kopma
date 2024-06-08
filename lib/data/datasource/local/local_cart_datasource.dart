import 'dart:developer';
import 'package:isar/isar.dart';
import 'package:kopma/data/model/cart/cart_collection.dart';
import 'package:kopma/data/model/item/item_model.dart';
import '../../../di/service_locator.dart';
import 'local_database.dart';


class LocalCartDataSource {
  final localDatabase = serviceLocator<LocalDatabase>();


  Future<bool> addItemToCart(ItemModel item) async {
    try {
      final db = localDatabase.db;
      CartCollection cartCollection = CartCollection(
          itemId: item.id,
          name: item.name,
          image: item.image,
          category: item.category,
          description: item.description,
          quantity: item.quantity,
          price: item.price,
          sellerId: item.sellerId,
          sellerName: item.sellerName,
          sellerEmail: item.sellerEmail,
          sellerAddress: item.sellerAddress,
          sellerImage: item.sellerImage);
      return await db
          .writeTxn(() async => db.cartCollections.put(cartCollection))
          .then((value) => true);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  Future<List<ItemModel>> getListItemFromCart() async {
    try {
      final db = localDatabase.db;
      return await db.cartCollections.where().findAll().then((value) =>
          value.map((item) =>
              ItemModel(
                id: item.id.toString(),
                name: item.name,
                image: item.image,
                category: item.category,
                description: item.description,
                quantity: item.quantity,
                price: item.price,
                sellerId: item.sellerId,
                sellerName: item.sellerName,
                sellerEmail: item.sellerEmail,
                sellerAddress: item.sellerAddress,
                sellerImage: item.sellerImage,
              )
          ).toList()
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  Future<bool> deleteItemFromCart(String itemId) async {
    try {
      final db = localDatabase.db;
      return await db.writeTxn(() async => db.cartCollections.filter().idEqualTo(int.parse(itemId)).deleteAll()).then((value) => true);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

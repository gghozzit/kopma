import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kopma/data/model/cart/cart_collection.dart';
import 'package:kopma/data/model/item/item_model.dart';
import 'package:kopma/ui/cart_page.dart';
import '../../../di/service_locator.dart';
import '../../model/item/item_entity.dart';
import '../../model/user/user_entity.dart';
import '../../model/user/user_model.dart';
import '../network/firebase_item_datasource.dart';
import '../shared_preferences_service.dart';
import 'local_database.dart';

class ItemAlreadyExistsException implements Exception {
  String message = 'Item already exists in your cart';
  ItemAlreadyExistsException(this.message);
}

class LocalCartDataSource {
  final localDatabase = serviceLocator<LocalDatabase>();
  final FirebaseItemDataSource _firebaseItemDataSource;
  LocalCartDataSource(this._firebaseItemDataSource);

  Future<bool> addItemToCart(ItemModel item) async {
    try {
      final db = localDatabase.db;

      // Check if the item already exists in the cart
      var existingItems = await db.cartCollections.filter().itemIdEqualTo(item.id).findAll();
      if (existingItems.isNotEmpty) {
        throw ItemAlreadyExistsException("Item with ID ${item.id} already exists in the cart.");
      }

      CartCollection cartCollection = CartCollection(
        itemId: item.id,
        name: item.name,
        image: item.image,
        category: item.category,
        description: item.description,
        quantity: 1,
        price: item.price,
        sellerId: item.sellerId,
        sellerName: item.sellerName,
        sellerEmail: item.sellerEmail,
        sellerAddress: item.sellerAddress,
        sellerImage: item.sellerImage,
      );

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
                itemId: item.itemId,
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
      int id = int.parse(itemId);
      return await db.writeTxn(() async => db.cartCollections.delete(id));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateItemQuantity(String? itemId, String itemIdFirebase, int newQuantity) async {
    int idItem = int.parse(itemId!);
    if (itemId == null) {
      log('Item ID is null');
      return false;
    }
    try {
      final db = localDatabase.db;
      final item = await db.cartCollections.filter().idEqualTo(idItem).findFirst();
      if (item != null) {
        final updatedItem = CartCollection(
          id: idItem,
          itemId: itemIdFirebase,
          name: item.name,
          image: item.image,
          category: item.category,
          description: item.description,
          quantity: newQuantity,
          price: item.price,
          sellerId: item.sellerId,
          sellerName: item.sellerName,
          sellerEmail: item.sellerEmail,
          sellerAddress: item.sellerAddress,
          sellerImage: item.sellerImage,
        );
        await db.writeTxn(() async => db.cartCollections.put(updatedItem));

        return true;
      }
      return false; // Item not found
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> buyItemFromCart(BuildContext context, String isarID, String itemId, int quantity) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing...'),
              ],
            ),
          );
        },
      );
      await _firebaseItemDataSource.buyItem(itemId, quantity);
      deleteItemFromCart(isarID);
      Navigator.of(context).pop();
      showOkAlertDialog(context: context, title: "Success", message: "Congrats! Your order is on its way!");
      return true;
    } catch (e) {
      log(e.toString());
      Navigator.of(context).pop();
      showOkAlertDialog(context: context, title: "Failed", message: e.toString());
      rethrow;
    }
  }

  Future<bool> batchBuyItem(BuildContext context, List<ItemModel> cartItems, int totalPrice) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing...'),
              ],
            ),
          );
        },
      );
      UserModel user = await FirebaseItemDataSource().usersCollection
          .doc(FirebaseItemDataSource().sharedPrefService.uid)
          .get()
          .then((value) =>
          UserModel.fromEntity(UserEntity.fromDocument(value.data()!)));
      int userBalance = user.balance ?? 0;

      if (userBalance >= totalPrice) {
        List<String> outOfStockItems = [];
        for (var cartItem in cartItems) {
          ItemModel item =
          await FirebaseItemDataSource().getDetailItem(cartItem.itemId!);
          if ((item.quantity - cartItem.quantity) >= 0) {} else {
            outOfStockItems.add(cartItem.name);
          }
        }
        if (outOfStockItems.isEmpty) {
          for (var cartItem in cartItems) {
            await _firebaseItemDataSource.buyItem(
                cartItem.itemId!, cartItem.quantity);
            deleteItemFromCart(cartItem.id!);
          }
          Navigator.of(context).pop();
          showOkAlertDialog(
              context: context,
              title: "Success",
              message: "Congrats! Your order is on its way!");
        } else {
          Navigator.of(context).pop();
          showOkAlertDialog(
            context: context,
            title: "Out of Stock Item(s)",
            message:
            "The following items are out of stock: ${outOfStockItems.join(', ')}",
          );
          return false;
        }
        return true;
      } else {
        Navigator.of(context).pop();
        showOkAlertDialog(
            context: context,
            title: "Failed",
            message: "Not enough balance!");
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop();
      log(e.toString());
      rethrow;
    }
  }


}

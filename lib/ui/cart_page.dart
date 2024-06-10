import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/datasource/local/local_cart_datasource.dart';
import '../data/datasource/network/firebase_item_datasource.dart';
import '../data/model/item/item_model.dart';
import 'detail_item_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  LocalCartDataSource cartDataSource =
  LocalCartDataSource(FirebaseItemDataSource());
  List<ItemModel> cartItems = [];
  bool isLoading = true;
  List<int> totalPricesPerItem = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      List<ItemModel> items = await cartDataSource.getListItemFromCart();
      setState(() {
        cartItems = items;
        totalPricesPerItem =
            items.map((item) => item.quantity * item.price).toList();
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching cart items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateTotalPrice() {
    return totalPricesPerItem.isEmpty
        ? 0
        : totalPricesPerItem.reduce((sum, element) => sum + element);
  }

  void _updateTotalPrice() {
    setState(() {
      totalPricesPerItem =
          cartItems.map((item) => item.quantity * item.price).toList();
    });
  }

  Future<void> _incrementQuantity(int index, String? itemIdFirebase) async {
    final item = cartItems[index];
    final newQuantity = item.quantity + 1;

    setState(() {
      cartItems[index] = item.copyWith(quantity: newQuantity);
      totalPricesPerItem[index] = newQuantity * item.price;
    });

    await cartDataSource.updateItemQuantity(
        item.id, itemIdFirebase!, newQuantity);
    _updateTotalPrice();
  }

  Future<void> _decrementQuantity(int index, String? itemIdFirebase) async {
    final item = cartItems[index];
    if (item.quantity > 1) {
      final newQuantity = item.quantity - 1;

      setState(() {
        cartItems[index] = item.copyWith(quantity: newQuantity);
        totalPricesPerItem[index] = newQuantity * item.price;
      });

      await cartDataSource.updateItemQuantity(
          item.id, itemIdFirebase!, newQuantity);
      _updateTotalPrice();
    }
  }

  Future<void> _buyItem(
      BuildContext context, String? itemIdIsar, String? itemId, int quantity) async {
    bool success =
    await cartDataSource.buyItemFromCart(context, itemIdIsar!, itemId!, quantity);
    if (success) {
      _fetchCartItems();
    }
  }

  Future<void> _buyAllItems(
      BuildContext context, List<ItemModel> cartItems, int totalPrice) async {
    bool success =
    await cartDataSource.batchBuyItem(context, cartItems, totalPrice);
    if (success) {
      _fetchCartItems();
    }
  }

  Future<void> _deleteItemFromCart(String? itemIdIsar) async {
    if (itemIdIsar != null && itemIdIsar.isNotEmpty) {
      try {
        bool success = await cartDataSource.deleteItemFromCart(itemIdIsar);
        if (success) {
          _fetchCartItems();
        } else {
          // Handle case when deletion was not successful
        }
      } catch (e) {
        log('Error deleting item from cart: $e');
        // Handle error condition
      }
    } else {
      log('Error deleting item from cart: itemIdIsar is empty or null');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = _calculateTotalPrice();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? const Center(child: Text('Keranjang Kosong'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: item.image.isNotEmpty
                          ? Image.network(
                        item.image,
                        fit: BoxFit.cover,
                      )
                          : const Center(child: Text('No image')),
                    ),
                    SizedBox(height: 8),
                    Text('Penjual: ${item.sellerName}'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              _decrementQuantity(index, item.itemId),
                          icon: const Icon(Icons.remove),
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          onPressed: () =>
                              _incrementQuantity(index, item.itemId),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _buyItem(
                              context,
                              item.id,
                              item.itemId,
                              item.quantity,
                            );
                          },
                          child: const Text('Beli'),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteItemFromCart(item.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    Text('Harga: ${currencyFormat.format(item.price)}'),
                    Text('Total: ${currencyFormat.format(item.price * item.quantity)}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harga Total : ${currencyFormat.format(totalPrice)}', // Format nominal rupiah
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  _buyAllItems(context, cartItems, totalPrice);
                },
                child: const Text('Beli Semua'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

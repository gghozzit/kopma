import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kopma/bloc/user_bloc/user_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import '../bloc/detail_item_bloc/detail_item_bloc.dart';

class CheckoutPage extends StatefulWidget {
  final ItemModel item;

  const CheckoutPage({Key? key, required this.item}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;
  late int _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.item.price;
  }

  void _incrementCounter() {
    setState(() {
      if (_quantity < widget.item.quantity) {
        _quantity += 1;
        _totalPrice = _quantity * widget.item.price;
        print('Incremented: quantity = $_quantity, totalPrice = $_totalPrice');
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
        _totalPrice = _quantity * widget.item.price;
        print('Decremented: quantity = $_quantity, totalPrice = $_totalPrice');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state is BuyItemFailure) {
            showOkAlertDialog(
              context: context,
              title: "Error",
              message: state.errorMessage,
            );
          } else if (state is BuyItemSuccess) {
            showOkAlertDialog(
              context: context,
              title: "Pembelian Berhasil",
              message: "Barangmu Sedang dalam Perjalanan",
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.item.image,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.item.description,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Harga:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(widget.item.price),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Jumlah:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: _decrementCounter,
                                        icon: Icon(Icons.remove),
                                      ),
                                      Text(_quantity.toString()),
                                      IconButton(
                                        onPressed: _incrementCounter,
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Penjual:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(widget.item.sellerName ?? ''),
                          Text(widget.item.sellerEmail ?? ''),
                          Text(widget.item.sellerAddress ?? ''),
                          SizedBox(height: 16),
                          Text(
                            'Pembeli:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(state.user?.name ?? ''),
                          Text(state.user?.address ?? ''),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Harga:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                currencyFormat.format(_totalPrice),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<DetailItemBloc>().add(
                                BuyItem(
                                  itemId: widget.item.id!,
                                  quantity: _quantity,
                                ),
                              );
                            },
                            child: Text('Bayar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

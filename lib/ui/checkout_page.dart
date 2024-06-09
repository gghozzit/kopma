import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/user_bloc/user_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import '../bloc/detail_item_bloc/detail_item_bloc.dart';

class CheckoutPage extends StatefulWidget {
  final ItemModel item;

  const CheckoutPage({super.key, required this.item});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;
  int _totalPrice = 1;

  void _incrementCounter() {
    setState(() {
      if (_quantity < widget.item.quantity) {
        _quantity += 1;
        _totalPrice = _quantity * widget.item.price;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
        _totalPrice = _quantity * widget.item.price;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.item.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocListener<DetailItemBloc, DetailItemState>(
          listener: (context, state) {
            if (state is BuyItemFailure) {
              showOkAlertDialog(
                  context: context,
                  title: "Error",
                  message: state.errorMessage);
            } else if (state is BuyItemSuccess) {
              showOkAlertDialog(
                  context: context,
                  title: "Success",
                  message: "Congrats! Your order is on its way!");
            }
          },
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.item.image,
                          width: 160,
                        ),
                        Column(
                          children: [
                            Text(widget.item.name),
                            Text(widget.item.price.toString()),
                            Card(
                              elevation: 4,
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _decrementCounter();
                                      },
                                      child: const Text("-")),
                                  Text(_quantity.toString()),
                                  TextButton(
                                      onPressed: () {
                                        _incrementCounter();
                                      },
                                      child: const Text("+")),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("From"),
                        Text(widget.item.sellerName ?? ""),
                        Text(widget.item.sellerEmail ?? ""),
                        Text(widget.item.sellerAddress ?? ""),
                        const Text("To"),
                        Text(state.user?.name ?? ""),
                        Text(state.user?.address ?? ""),
                      ],
                    ),
                  ),
                  Card(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text("Total Price"),
                            Text(_totalPrice.toString())
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                context.read<DetailItemBloc>().add(BuyItem(
                                    itemId: widget.item.id!,
                                    quantity: _quantity));
                              });
                            },
                            child: const Text("Pay Now"))
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}

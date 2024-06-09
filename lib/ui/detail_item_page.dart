import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import 'checkout_page.dart';

class DetailItemPage extends StatefulWidget {
  final String idItem;

  const DetailItemPage({super.key, required this.idItem});

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state == const DetailItemState.empty()) {
            const Text("No Data");
          }
          if (state is AddItemToCartFailure) {
            showOkAlertDialog(
                context: context, title: "Error", message: state.errorMessage);
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is AddItemToCartSuccess) {
            showOkAlertDialog(
                context: context,
                title: "Masuk Keranjang",
                message:
                "Alhamdulillah ${state.item?.name} sudah masuk keranjang.");
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemSuccess) {
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemFailure) {
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          }
        },
        child: BlocBuilder<DetailItemBloc, DetailItemState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child:
                      Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            state.item?.name ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: state.item?.image ?? "",
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Text('(' + (state.item?.category ?? "") + ')'),
                          Text('Rp.' +
                              (state.item?.price.toString() ?? ""),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Deskripsi",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            state.item?.description ?? "",
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.item?.sellerName ?? ""),
                          Text(state.item?.sellerAddress ?? ""),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 6,
                      child: Row(
                        children: [
                          OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  context
                                      .read<DetailItemBloc>()
                                      .add(AddItemToCart(item: state.item!));
                                });
                              },
                              icon: const Icon(Icons.trolley),
                              label: const Text("Masukkan Keranjang")),
                          const Padding(
                              padding: EdgeInsets.only(left: 5, right: 5)),
                          Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CheckoutPage(
                                            item: state.item ?? ItemModel.empty);
                                      }));
                                },
                                child: const Text("Beli"),
                              )),
                        ],
                      ),
                    )
                  ]),
            );
          },
        ),
      ),
    );
  }
}

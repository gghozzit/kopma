import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';
import 'package:intl/intl.dart';

import 'checkout_page.dart';

class DetailItemPage extends StatefulWidget {
  final String idItem;

  const DetailItemPage({Key? key, required this.idItem}) : super(key: key);

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
              context: context,
              title: "Error",
              message: state.errorMessage,
            );
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is AddItemToCartSuccess) {
            showOkAlertDialog(
              context: context,
              title: "Masuk Keranjang",
              message: "Alhamdulillah ${state.item?.name} sudah masuk keranjang.",
            );
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
                    elevation: 6,
                    margin: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            state.item?.name ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text('(' + (state.item?.category ?? "") + ')'),
                          trailing: Text(
                            'Rp ' + (state.item?.price != null ? NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(state.item!.price) : ''),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18, // Menonjolkan ukuran harga
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: state.item?.image ?? "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deskripsi",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              state.item?.description ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Informasi Penjual",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              state.item?.sellerName ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              state.item?.sellerAddress ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<DetailItemBloc>()
                                  .add(AddItemToCart(item: state.item!));
                            },
                            icon: Icon(Icons.shopping_cart),
                            label: Text("Masukkan Keranjang"),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutPage(item: state.item ?? ItemModel.empty)));
                            },
                            child: Text("Beli"),
                          ),
                        ),
                      ],
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
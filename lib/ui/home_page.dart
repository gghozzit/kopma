import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kopma/bloc/item_bloc/item_bloc.dart';
import 'package:kopma/data/model/item/item_entity.dart';
import 'package:kopma/ui/detail_item_page.dart';
import 'package:kopma/ui/post_item_page.dart';
import '../data/model/item/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(const GetListItems(query: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk Dijual'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add item',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const PostItemPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is UploadItemSuccess) {
            context.read<ItemBloc>().add(const GetListItems(query: ""));
          }
        },
        child: BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
          if (state is GetListItemSuccess) {
            return FirestoreQueryBuilder<Map<String, dynamic>>(
              query: state.listItem,
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong! ${snapshot.error}'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      snapshot.fetchMore();
                    }

                    final item = snapshot.docs[index].data();

                    return ItemWidget(item: ItemModel.fromEntity(ItemEntity.fromDocument(item)));
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Error'));
          }
        }),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final ItemModel item;

  const ItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return GestureDetector(
      onTap: () {
        if (item.id != null && item.id!.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailItemPage(idItem: item.id!);
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID item tidak valid')),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(item.price),
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/item_bloc/item_bloc.dart';
import 'package:kopma/data/model/item/item_entity.dart';
import 'package:kopma/ui/detail_item_page.dart';
import 'package:kopma/ui/post_item_page.dart';
import '../data/model/item/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

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
          if(state is UploadItemSuccess) {
            context.read<ItemBloc>().add(const GetListItems(query: ""));
          }
        },
        child: BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
          if (state is GetListItemSuccess) {
            return FirestoreQueryBuilder<Map<String, dynamic>>(
              query: state.listItem,
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6
                  ),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    // if we reached the end of the currently obtained items, we try to
                    // obtain more items
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      // Tell FirestoreQueryBuilder to try to obtain more items.
                      // It is safe to call this function from within the build method.
                      snapshot.fetchMore();
                    }

                    final item = snapshot.docs[index].data();

                    return ItemWidget(item: ItemModel.fromEntity(ItemEntity.fromDocument(item)));
                  },
                );
              },
            );
          } else {
            return const Text('Error Wahai Rakyat Indonesia');
          }
        }),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final ItemModel item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.id != null) {
          if (item.id!.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailItemPage(idItem: item.id!);
            }));
          }
        }
      },
      child: Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: item.image,
                  height: 180,
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Text(
                  item.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Text(
                  "Rp. ${item.price}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )),
    );
  }
}

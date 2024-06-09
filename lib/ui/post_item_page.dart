import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopma/bloc/item_bloc/item_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

class PostItemPage extends StatefulWidget {
  const PostItemPage({Key? key}) : super(key: key);

  @override
  State<PostItemPage> createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  String categoriesValue = 'Books';
  final categories = [
    'Books',
    'Business & Industrial',
    'Clothing, Shoes & Accessories',
    'Collectibles',
    'Consumer Electronics',
    'Crafts',
    'Dolls & Bears',
    'Home & Garden',
    'Motors',
    'Pet Supplies',
    'Sporting Goods',
    'Sports Mem, Cards & Fan Shop',
    'Toys & Hobbies',
    'Antiques',
    'Computers/Tablets & Networking'
  ];

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://via.assets.so/img.jpg?w=800&h=800&tc=&bg=#cecece&t=Image";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jual Barang"),
      ),
      body: BlocListener<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is UploadItemSuccess) {
            if (state.isSuccess) {
              showOkAlertDialog(
                context: context,
                title: "Success",
                message: "Your item is live and ready to sell.",
              );
              setState(() {
                nameController.text = "";
                descriptionController.text = "";
                quantityController.text = "";
                priceController.text = "";
              });
            } else {
              showOkAlertDialog(
                context: context,
                title: "Error",
                message:
                "Please complete your profile information, including your name and address.",
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  imageUrl = state.imageUrl ??
                      "https://via.assets.so/img.jpg?w=800&h=800&tc=&bg=#cecece&t=Image";
                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                  );
                },
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () async {
                  final XFile? images =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (context.mounted) {
                    context.read<ItemBloc>().add(UploadImage(
                      file: File(images!.path),
                      fileName: images.name,
                    ));
                  }
                },
                icon: const Icon(Icons.add_a_photo_rounded),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama Barang',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Deskripsi Barang',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: categoriesValue,
                onChanged: (newValue) {
                  setState(() {
                    categoriesValue = newValue!;
                  });
                },
                items: categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Stok Barang',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Harga Barang',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    context.read<ItemBloc>().add(
                      PostItem(
                        item: ItemModel(
                          name: nameController.text,
                          image: imageUrl,
                          category: categoriesValue,
                          description: descriptionController.text,
                          quantity: int.parse(quantityController.text),
                          price: int.parse(priceController.text),
                        ),
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.add_business_rounded),
                label: const Text("Jual Barang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

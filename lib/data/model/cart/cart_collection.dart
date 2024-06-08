import 'package:isar/isar.dart';

part 'cart_collection.g.dart';


@collection
class CartCollection {
  final Id id = Isar.autoIncrement;
  final String? itemId;
  final String name;
  final String image;
  final String category;
  final String description;
  final int quantity;
  final int price;
  final String? sellerId;
  final String? sellerName;
  final String? sellerEmail;
  final String? sellerAddress;
  final String? sellerImage;


  const CartCollection({
    required this.itemId,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.quantity,
    required this.price,
    this.sellerId,
    this.sellerName,
    this.sellerEmail,
    this.sellerAddress,
    this.sellerImage,
  });
}

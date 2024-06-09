import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String category;
  final String description;
  final int quantity;
  final int price;
  final String sellerId;
  final String sellerName;
  final String sellerEmail;
  final String sellerAddress;
  final String? sellerImage;

  const ItemEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.quantity,
    required this.price,
    required this.sellerId,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerAddress,
    required this.sellerImage,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'description': description,
      'quantity': quantity,
      'price': price,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerEmail': sellerEmail,
      'sellerAddress': sellerAddress,
      'sellerImage': sellerImage,
    };
  }

  static ItemEntity fromDocument(Map<String, dynamic> doc) {
    return ItemEntity(
      id: doc['id'] as String,
      name: doc['name'] as String,
      image: doc['image'] as String,
      category: doc['category'] as String,
      description: doc['description'] as String,
      quantity: doc['quantity'],
      price: doc['price'],
      sellerId: doc['sellerId'] as String,
      sellerName: doc['sellerName'] as String,
      sellerEmail: doc['sellerEmail'] as String,
      sellerAddress: doc['sellerAddress'] as String,
      sellerImage: doc['sellerImage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    category,
    description,
    quantity,
    price,
    sellerId,
    sellerName,
    sellerEmail,
    sellerAddress,
    sellerImage
  ];

  @override
  String toString() {
    return '''ItemEntity: {
      id: $id
      name: $name
      image: $image
      category: $category
      description: $description
      quantity: $quantity
      price: $price
      sellerId: $sellerId
      sellerName: $sellerName
      sellerEmail: $sellerEmail
      sellerAddress: $sellerAddress
      sellerImage: $sellerImage
    }''';
  }
}
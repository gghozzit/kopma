import 'package:equatable/equatable.dart';
import 'item_entity.dart';

class ItemModel extends Equatable {
  final String? id;
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
  final String? itemId;

  const ItemModel({
    this.id,
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
    this.itemId,
  });

  /// Empty item.
  static const empty = ItemModel(
    id: '',
    name: '',
    image: '',
    category: '',
    description: '',
    quantity: 0,
    price: 0,
    sellerId: '',
    sellerName: '',
    sellerEmail: '',
    sellerAddress: '',
    sellerImage: '',
  );

  /// Modify item parameters
  ItemModel copyWith({
    String? id,
    String? itemId,
    String? name,
    String? image,
    String? category,
    String? description,
    int? quantity,
    int? price,
    String? sellerId,
    String? sellerName,
    String? sellerEmail,
    String? sellerAddress,
    String? sellerImage,
  }) {
    return ItemModel(
      id: id ?? this.id,
      itemId: this.itemId,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerEmail: sellerEmail ?? this.sellerEmail,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      sellerImage: sellerImage ?? this.sellerImage,
    );
  }

  /// Convenience getter to determine whether the current item is empty.
  bool get isEmpty => this == ItemModel.empty;

  /// Convenience getter to determine whether the current item is not empty.
  bool get isNotEmpty => this != ItemModel.empty;

  ItemEntity toEntity(
      String id, String sellerId, String sellerName, String sellerEmail, String sellerAddress, String? sellerImage) {
    return ItemEntity(
      id: id,
      name: name,
      image: image,
      category: category,
      description: description,
      quantity: quantity,
      price: price,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerEmail: sellerEmail,
      sellerAddress: sellerAddress,
      sellerImage: sellerImage,
    );
  }

  static ItemModel fromEntity(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      category: entity.category,
      description: entity.description,
      quantity: entity.quantity,
      price: entity.price,
      sellerId: entity.sellerId,
      sellerName: entity.sellerName,
      sellerEmail: entity.sellerEmail,
      sellerAddress: entity.sellerAddress,
      sellerImage: entity.sellerImage,
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
    sellerImage,
  ];
}

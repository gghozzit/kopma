import 'package:equatable/equatable.dart';
import 'package:kopma/data/model/transaction/transaction_entity.dart';


class TransactionModel extends Equatable {
  final String id;
  final DateTime dateTime;
  final String itemId;
  final String itemName;
  final String itemImage;
  final int itemQuantity;
  final int itemPrice;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final String buyerAddress;
  final int buyerMoney;
  final String sellerId;
  final String sellerName;
  final String sellerEmail;
  final String sellerAddress;
  final String? sellerImage;


  const TransactionModel({
    required this.id,
    required this.dateTime,
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemQuantity,
    required this.itemPrice,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerAddress,
    required this.buyerMoney,
    required this.sellerId,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerAddress,
    required this.sellerImage,
  });


  /// Empty item.
  static TransactionModel empty = TransactionModel(
    id: '',
    dateTime: DateTime.now(),
    itemId: '',
    itemName: '',
    itemImage: '',
    itemQuantity: 0,
    itemPrice: 0,
    buyerId: '',
    buyerName: '',
    buyerEmail: '',
    buyerAddress: '',
    buyerMoney: 0,
    sellerId: '',
    sellerName: '',
    sellerEmail: '',
    sellerAddress: '',
    sellerImage: '',
  );


  /// Modify item parameters
  TransactionModel copyWith({
    String? id,
    DateTime? dateTime,
    String? itemId,
    String? itemName,
    String? itemImage,
    int? itemQuantity,
    int? itemPrice,
    String? buyerId,
    String? buyerName,
    String? buyerEmail,
    String? buyerAddress,
    int? buyerMoney,
    String? sellerId,
    String? sellerName,
    String? sellerEmail,
    String? sellerAddress,
    String? sellerImage,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      itemImage: itemImage ?? this.itemImage,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemPrice: itemPrice ?? this.itemPrice,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      buyerMoney: buyerMoney ?? this.buyerMoney,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerEmail: sellerEmail ?? this.sellerEmail,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      sellerImage: sellerImage ?? this.sellerImage,
    );
  }


  /// Convenience getter to determine whether the current item is empty.
  bool get isEmpty => this == TransactionModel.empty;


  /// Convenience getter to determine whether the current item is not empty.
  bool get isNotEmpty => this != TransactionModel.empty;


  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      dateTime: dateTime,
      itemId: itemId,
      itemName: itemName,
      itemImage: itemImage,
      itemQuantity: itemQuantity,
      itemPrice: itemPrice,
      buyerId: buyerId,
      buyerName: buyerName,
      buyerEmail: buyerEmail,
      buyerAddress: buyerAddress,
      buyerMoney: buyerMoney,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerEmail: sellerEmail,
      sellerAddress: sellerAddress,
      sellerImage: sellerImage,
    );
  }


  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      dateTime: entity.dateTime,
      itemId: entity.itemId,
      itemName: entity.itemName,
      itemImage: entity.itemImage,
      itemQuantity: entity.itemQuantity,
      itemPrice: entity.itemPrice,
      buyerId: entity.buyerId,
      buyerName: entity.buyerName,
      buyerEmail: entity.buyerEmail,
      buyerAddress: entity.buyerAddress,
      buyerMoney: entity.buyerMoney,
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
    dateTime,
    itemId,
    itemName,
    itemImage,
    itemQuantity,
    itemPrice,
    buyerId,
    buyerName,
    buyerEmail,
    buyerAddress,
    buyerMoney,
    sellerId,
    sellerName,
    sellerEmail,
    sellerAddress,
    sellerImage,
  ];
}

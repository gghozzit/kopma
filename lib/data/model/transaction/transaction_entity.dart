import 'package:equatable/equatable.dart';


class TransactionEntity extends Equatable {
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


  const TransactionEntity({
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


  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'dateTime': dateTime,
      'itemId': itemId,
      'itemName': itemName,
      'itemImage': itemImage,
      'itemQuantity': itemQuantity,
      'itemPrice': itemPrice,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerAddress': buyerAddress,
      'buyerMoney': buyerMoney,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerEmail': sellerEmail,
      'sellerAddress': sellerAddress,
      'sellerImage': sellerImage,
    };
  }


  static TransactionEntity fromDocument(Map<String, dynamic> doc) {
    return TransactionEntity(
      id: doc['id'] as String,
      dateTime: doc['dateTime'],
      itemId: doc['itemId'] as String,
      itemName: doc['itemName'] as String,
      itemImage: doc['itemImage'] as String,
      itemQuantity: doc['itemQuantity'],
      itemPrice: doc['itemPrice'],
      buyerId: doc['buyerId'] as String,
      buyerName: doc['buyerName'] as String,
      buyerEmail: doc['buyerEmail'] as String,
      buyerAddress: doc['buyerAddress'] as String,
      buyerMoney: doc['buyerMoney'],
      sellerId: doc['sellerId'] as String,
      sellerName: doc['sellerName'] as String,
      sellerEmail: doc['sellerEmail'] as String,
      sellerAddress: doc['sellerAddress'] as String,
      sellerImage: doc['sellerImage'] as String,
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


  @override
  String toString() {
    return '''TransactionEntity: {
     id: $id
     dateTime: $dateTime
     itemId: $itemId
     itemName: $itemName
     itemImage: $itemImage
     itemQuantity: $itemQuantity
     itemPrice: $itemPrice
     buyerId: $buyerId
     buyerName: $buyerName
     buyerEmail: $buyerEmail
     buyerAddress: $buyerAddress
     buyerMoney: $buyerMoney
     sellerId: $sellerId
     sellerName: $sellerName
     sellerEmail: $sellerEmail
     sellerAddress: $sellerAddress
     sellerImage: $sellerImage
   }''';
  }
}

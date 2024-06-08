part of 'detail_item_bloc.dart';


abstract class DetailItemEvent extends Equatable {
  const DetailItemEvent();


  @override
  List<Object> get props => [];
}


class GetDetailItem extends DetailItemEvent {
  final String itemId;


  const GetDetailItem({required this.itemId});


  @override
  List<Object> get props => [itemId];
}


class BuyItem extends DetailItemEvent {
  final String itemId;
  final int quantity;


  const BuyItem({required this.itemId, required this.quantity});


  @override
  List<Object> get props => [itemId, quantity];
}


class AddItemToCart extends DetailItemEvent {
  final ItemModel item;


  const AddItemToCart({required this.item,});


  @override
  List<Object> get props => [item,];
}


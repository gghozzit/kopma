part of 'item_bloc.dart';


abstract class ItemEvent extends Equatable {
  const ItemEvent();


  @override
  List<Object> get props => [];
}


class PostItem extends ItemEvent {
  final ItemModel item;


  const PostItem({required this.item});


  @override
  List<Object> get props => [item];
}


class UploadImage extends ItemEvent {
  final File file;
  final String fileName;


  const UploadImage({required this.file, required this.fileName});




  @override
  List<Object> get props => [file];
}


class GetListItems extends ItemEvent {
  final String? query;


  const GetListItems({this.query});
  @override
  List<Object> get props => [];
}



class GetDetailItem extends ItemEvent {
  final String itemId;


  const GetDetailItem({required this.itemId});


  @override
  List<Object> get props => [itemId];
}


class DeleteItem extends ItemEvent {
  final String itemId;


  const DeleteItem({required this.itemId});


  @override
  List<Object> get props => [itemId];
}



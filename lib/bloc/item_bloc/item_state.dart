part of 'item_bloc.dart';

enum ItemStatus { success, loading, failure, isDeleted }

class ItemState extends Equatable {

  final ItemStatus status;
  final String? imageUrl;
  final bool? isDeleted;

  const ItemState._({
    this.status = ItemStatus.loading,
    this.imageUrl,
    this.isDeleted
  });

  const ItemState.loading() : this._();

  const ItemState.successUploadImage(String imageUrl) : this._(status: ItemStatus.success, imageUrl: imageUrl);

  const ItemState.isDeleted(bool isDeleted) : this._(status: ItemStatus.isDeleted, isDeleted: isDeleted);

  const ItemState.failure() : this._(status: ItemStatus.failure);

  @override
  List<Object?> get props => [status, imageUrl, isDeleted];
}

final class GetListItemSuccess extends ItemState {
  final Query<Map<String, dynamic>> listItem;

  const GetListItemSuccess(this.listItem) : super.failure();
}

final class UploadItemSuccess extends ItemState {
  final bool isSuccess;
  final ItemModel item;

  const UploadItemSuccess(this.isSuccess, this.item) : super.failure();
}
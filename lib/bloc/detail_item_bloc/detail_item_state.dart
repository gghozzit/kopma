part of 'detail_item_bloc.dart';

enum DetailItemStatus { initial, empty, loading, success, failure }

class DetailItemState extends Equatable {
  final DetailItemStatus status;
  final ItemModel? item;

  const DetailItemState._({
    this.status = DetailItemStatus.loading,
    this.item = ItemModel.empty,
  });

  const DetailItemState.initial() : this._(status: DetailItemStatus.initial);

  const DetailItemState.loading() : this._();

  const DetailItemState.empty() : this._(status: DetailItemStatus.empty, item: ItemModel.empty);

  const DetailItemState.success(ItemModel item) : this._(status: DetailItemStatus.success, item: item);

  const DetailItemState.failure() : this._(status: DetailItemStatus.failure);

  @override
  List<Object> get props => [status];
}

final class BuyItemFailure extends DetailItemState {
  final String errorMessage;

  const BuyItemFailure(this.errorMessage): super.failure();
}

final class BuyItemLoading extends DetailItemState {
  const BuyItemLoading.empty() : super.failure();
}

final class BuyItemSuccess extends DetailItemState {
  final bool isSuccess;

  const BuyItemSuccess(this.isSuccess) : super.failure();
}

final class AddItemToCartFailure extends DetailItemState {
  final String errorMessage;

  const AddItemToCartFailure(this.errorMessage): super.failure();
}

final class AddItemToCartLoading extends DetailItemState {
  const AddItemToCartLoading.empty() : super.failure();
}

final class AddItemToCartSuccess extends DetailItemState {
  final bool isSuccess;

  const AddItemToCartSuccess(this.isSuccess) : super.failure();
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kopma/data/model/item/item_model.dart';
import '../../data/item_repository.dart';
import 'dart:developer';


part 'detail_item_event.dart';
part 'detail_item_state.dart';


class DetailItemBloc extends Bloc<DetailItemEvent, DetailItemState> {
  final ItemRepository itemRepository;


  DetailItemBloc({required this.itemRepository}) : super(const DetailItemState.initial()) {
    on<GetDetailItem>((event, emit) async {
      try {
        emit(const DetailItemState.loading());
        final item = await itemRepository.getDetailItem(event.itemId);
        if(item == ItemModel.empty) {
          emit(const DetailItemState.empty());
        } else {
          emit(DetailItemState.success(item));
        }
      } catch (e) {
        log(e.toString());
        emit(const DetailItemState.failure());
      }
    });


    on<BuyItem>((event, emit) async {
      try {
        emit(const BuyItemLoading.empty());
        final result = await itemRepository.buyItem(event.itemId, event.quantity);
        emit(BuyItemSuccess(result));
      } catch (e) {
        log(e.toString());
        emit(BuyItemFailure(e.toString()));
      }
    });


    on<AddItemToCart>((event, emit) async {
      try {
        emit(const AddItemToCartLoading.empty());
        final result = await itemRepository.addItemToCart(event.item);
        emit(AddItemToCartSuccess(result));
      } catch (e) {
        log(e.toString());
        emit(AddItemToCartFailure(e.toString()));
      }
    });
  }
}

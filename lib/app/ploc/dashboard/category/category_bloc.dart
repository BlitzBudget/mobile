import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/dashboard/category/delete_category_use_case.dart'
    as delete_category_usecase;

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required this.deleteCategoryUseCase}) : super(Empty());

  final delete_category_usecase.DeleteCategoryUseCase deleteCategoryUseCase;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    yield Loading();

    if (event is Delete) {
      await deleteCategoryUseCase.delete(itemId: event.deleteItemId!);
    }
  }
}

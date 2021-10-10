import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import '../../../../domain/usecases/dashboard/category/delete_category_use_case.dart'
    as delete_category_usecase;
import 'category_constants.dart' as constants;

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
      final deleteResponse =
          await deleteCategoryUseCase.delete(itemId: event.deleteItemId!);
      yield deleteResponse.fold(_convertToMessage, _successResponse);
    }
  }

  CategoryState _successResponse(void r) {
    return Success();
  }

  CategoryState _convertToMessage(Failure failure) {
    debugPrint('Converting category failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

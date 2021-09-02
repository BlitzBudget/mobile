import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import '../../../../domain/usecases/dashboard/category/delete_category_use_case.dart'
    as delete_category_usecase;
import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import 'category_constants.dart' as constants;

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(
      {required this.deleteCategoryUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final delete_category_usecase.DeleteCategoryUseCase deleteCategoryUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    yield Loading();

    if (event is Delete) {
      final deleteResponse =
          await deleteCategoryUseCase.delete(itemId: event.deleteItemId!);
      deleteResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<CategoryState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<CategoryState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

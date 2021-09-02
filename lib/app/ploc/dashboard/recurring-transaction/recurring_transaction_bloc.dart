import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';

import '../../../../domain/entities/category/category_type.dart';
import '../../../../domain/entities/transaction/recurrence.dart';
import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import '../../../../domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart'
    as update_recurring_transaction_use_case;
import 'recurring_transaction_constants.dart' as constants;

part 'recurring_transaction_event.dart';
part 'recurring_transaction_state.dart';

class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  RecurringTransactionBloc(
      {required this.updateRecurringTransactionUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final update_recurring_transaction_use_case.UpdateRecurringTransactionUseCase
      updateRecurringTransactionUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  @override
  Stream<RecurringTransactionState> mapEventToState(
    RecurringTransactionEvent event,
  ) async* {
    yield Loading();

    if (event is Update) {
      final updateRecurringTransaction = RecurringTransaction(
          recurringTransactionId: event.recurringTransactionId,
          walletId: event.walletId,
          amount: event.amount,
          description: event.description,
          accountId: event.accountId,
          recurrence: event.recurrence,
          categoryType: event.categoryType,
          categoryName: event.categoryName,
          category: event.category,
          tags: event.tags);
      final updateResponse = await updateRecurringTransactionUseCase.update(
          updateRecurringTransaction: updateRecurringTransaction);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateAccountID) {
      final updateResponse = await updateRecurringTransactionUseCase.updateAccountId(
          accountId: event.accountId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateAmount) {
      final updateResponse = await updateRecurringTransactionUseCase.updateAmount(
          newAmount: event.amount);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateCategoryID) {
      final updateResponse = await updateRecurringTransactionUseCase.updateCategoryId(
          categoryId: event.category);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateDescription) {
      final updateResponse = await updateRecurringTransactionUseCase.updateDescription(
          description: event.description);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateRecurrence) {
      final updateResponse = await updateRecurringTransactionUseCase.updateRecurrence(
          recurrence: event.recurrence);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateTags) {
      final updateResponse = await updateRecurringTransactionUseCase.updateTags(tags: event.tags);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<RecurringTransactionState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<RecurringTransactionState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

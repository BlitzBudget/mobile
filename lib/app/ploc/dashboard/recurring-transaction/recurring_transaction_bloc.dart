import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/recurring-transaction/delete_recurring_transaction_use_case.dart'
    as delete_recurring_transaction_use_case;

import '../../../../domain/entities/category/category_type.dart';
import '../../../../domain/entities/transaction/recurrence.dart';
import '../../../../domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart'
    as update_recurring_transaction_use_case;
import 'recurring_transaction_constants.dart' as constants;

part 'recurring_transaction_event.dart';
part 'recurring_transaction_state.dart';

class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  RecurringTransactionBloc(
      {required this.deleteRecurringTransactionUseCase,
      required this.updateRecurringTransactionUseCase})
      : super(Empty());

  final update_recurring_transaction_use_case.UpdateRecurringTransactionUseCase
      updateRecurringTransactionUseCase;
  final delete_recurring_transaction_use_case.DeleteRecurringTransactionUseCase
      deleteRecurringTransactionUseCase;

  Stream<RecurringTransactionState> mapEventToState(
    RecurringTransactionEvent event,
  ) async* {
    yield Loading();

    if (event is UpdateAccountID) {
      final updateResponse =
          await updateRecurringTransactionUseCase.updateAccountId(
              accountId: event.accountId,
              recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateAmount) {
      final updateResponse =
          await updateRecurringTransactionUseCase.updateAmount(
              newAmount: event.amount,
              recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateCategoryID) {
      final updateResponse =
          await updateRecurringTransactionUseCase.updateCategoryId(
              categoryId: event.category,
              recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateDescription) {
      final updateResponse =
          await updateRecurringTransactionUseCase.updateDescription(
              description: event.description,
              recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateRecurrence) {
      final updateResponse =
          await updateRecurringTransactionUseCase.updateRecurrence(
              recurrence: event.recurrence,
              recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateTags) {
      final updateResponse = await updateRecurringTransactionUseCase.updateTags(
          tags: event.tags,
          recurringTransactionId: event.recurringTransactionId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Delete) {
      final deleteResponse = await deleteRecurringTransactionUseCase.delete(
          itemID: event.recurringTransactionId!);
      yield deleteResponse.fold(_convertToMessage, _successResponse);
    }
  }

  RecurringTransactionState _successResponse(void r) {
    return Success();
  }

  RecurringTransactionState _convertToMessage(Failure failure) {
    debugPrint(
        'Converting transaction failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

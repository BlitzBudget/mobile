import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

import '../../../../domain/entities/category/category_type.dart';
import '../../../../domain/entities/transaction/recurrence.dart';
import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import '../../../../domain/usecases/dashboard/transaction/add_transaction_use_case.dart'
    as add_transaction_use_case;
import '../../../../domain/usecases/dashboard/transaction/delete_transaction_use_case.dart'
    as delete_transaction_use_case;
import '../../../../domain/usecases/dashboard/transaction/fetch_transaction_use_case.dart'
    as fetch_transaction_use_case;
import '../../../../domain/usecases/dashboard/transaction/update_transaction_use_case.dart'
    as update_transaction_use_case;
import 'transaction_constants.dart' as constants;

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(
      {required this.updateTransactionUseCase,
      required this.addTransactionUseCase,
      required this.deleteTransactionUseCase,
      required this.fetchTransactionUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final fetch_transaction_use_case.FetchTransactionUseCase
      fetchTransactionUseCase;
  final update_transaction_use_case.UpdateTransactionUseCase
      updateTransactionUseCase;
  final add_transaction_use_case.AddTransactionUseCase addTransactionUseCase;
  final delete_transaction_use_case.DeleteTransactionUseCase
      deleteTransactionUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    yield Loading();

    if (event is Fetch) {
      await fetchTransactionUseCase.fetch();
    } else if (event is Add) {
      final addTransaction = Transaction(
          transactionId: event.transactionId,
          walletId: event.walletId,
          amount: event.amount,
          description: event.description,
          accountId: event.accountId,
          dateMeantFor: event.dateMeantFor,
          categoryId: event.categoryId,
          recurrence: event.recurrence,
          categoryType: event.categoryType,
          categoryName: event.categoryName,
          tags: event.tags);
      final addResponse =
          await addTransactionUseCase.add(addTransaction: addTransaction);
      addResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Update) {
      final updateTransaction = Transaction(
          transactionId: event.transactionId,
          walletId: event.walletId,
          amount: event.amount,
          description: event.description,
          accountId: event.accountId,
          dateMeantFor: event.dateMeantFor,
          categoryId: event.categoryId,
          recurrence: event.recurrence,
          categoryType: event.categoryType,
          categoryName: event.categoryName,
          tags: event.tags);
      final updateResponse = await updateTransactionUseCase.update(
          updateTransaction: updateTransaction);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateAccountID) {
      final updateResponse = await updateTransactionUseCase.updateAccountId(
          accountId: event.accountId, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateAmount) {
      final updateResponse = await updateTransactionUseCase.updateAmount(
          newAmount: event.amount, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateCategoryID) {
      final updateResponse = await updateTransactionUseCase.updateCategoryId(
          categoryId: event.categoryId, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateDescription) {
      final updateResponse = await updateTransactionUseCase.updateDescription(
          description: event.description, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateRecurrence) {
      final updateResponse = await updateTransactionUseCase.updateRecurrence(
          recurrence: event.recurrence, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateTags) {
      final updateResponse = await updateTransactionUseCase.updateTags(
          tags: event.tags, transactionId: event.transactionId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Delete) {
      final deleteResponse =
          await deleteTransactionUseCase.delete(itemID: event.transactionId!);
      deleteResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<TransactionState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<TransactionState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

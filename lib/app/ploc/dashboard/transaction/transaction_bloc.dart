import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

import '../../../../domain/entities/category/category_type.dart';
import '../../../../domain/entities/transaction/recurrence.dart';
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
      required this.fetchTransactionUseCase})
      : super(Empty()) {
    on<Fetch>(_onFetch);
    on<Add>(_onAdd);
    on<Delete>(_onDelete);
    on<UpdateAccountID>(_onUpdateAccountID);
    on<UpdateAmount>(_onUpdateAmount);
    on<UpdateCategoryID>(_onUpdateCategoryID);
    on<UpdateDescription>(_onUpdateDescription);
    on<UpdateRecurrence>(_onUpdateRecurrence);
    on<UpdateTags>(_onUpdateTags);
  }

  final fetch_transaction_use_case.FetchTransactionUseCase
      fetchTransactionUseCase;
  final update_transaction_use_case.UpdateTransactionUseCase
      updateTransactionUseCase;
  final add_transaction_use_case.AddTransactionUseCase addTransactionUseCase;
  final delete_transaction_use_case.DeleteTransactionUseCase
      deleteTransactionUseCase;

  FutureOr<void> _onFetch(Fetch event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final fetchResponse = await fetchTransactionUseCase.fetch();
    emit(fetchResponse.fold(_convertToMessage, _successfulFetchResponse));
  }

  FutureOr<void> _onAdd(Add event, Emitter<TransactionState> emit) async {
    emit(Loading());
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
    emit(addResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onDelete(Delete event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final deleteResponse =
        await deleteTransactionUseCase.delete(itemID: event.transactionId!);
    emit(deleteResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateAccountID(
      UpdateAccountID event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateAccountId(
        accountId: event.accountId, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateAmount(
      UpdateAmount event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateAmount(
        newAmount: event.amount, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateCategoryID(
      UpdateCategoryID event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateCategoryId(
        categoryId: event.categoryId, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateDescription(
      UpdateDescription event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateDescription(
        description: event.description, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateRecurrence(
      UpdateRecurrence event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateRecurrence(
        recurrence: event.recurrence, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateTags(
      UpdateTags event, Emitter<TransactionState> emit) async {
    emit(Loading());
    final updateResponse = await updateTransactionUseCase.updateTags(
        tags: event.tags, transactionId: event.transactionId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  TransactionState _successResponse(void r) {
    return Success();
  }

  TransactionState _successfulFetchResponse(
      TransactionResponse transactionModel) {
    return TransactionsFetched(transactionModel: transactionModel);
  }

  TransactionState _convertToMessage(Failure failure) {
    debugPrint('Converting wallet failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this.updateTransactionUseCase, this.addTransactionUseCase,
      this.deleteTransactionUseCase, this.fetchTransactionUseCase)
      : super(Empty());

  final fetch_transaction_use_case.FetchTransactionUseCase
      fetchTransactionUseCase;
  final update_transaction_use_case.UpdateTransactionUseCase
      updateTransactionUseCase;
  final add_transaction_use_case.AddTransactionUseCase addTransactionUseCase;
  final delete_transaction_use_case.DeleteTransactionUseCase
      deleteTransactionUseCase;

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
      await addTransactionUseCase.add(addTransaction: addTransaction);
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
      await updateTransactionUseCase.update(
          updateTransaction: updateTransaction);
    } else if (event is UpdateAccountID) {
      await updateTransactionUseCase.updateAccountId(
          accountId: event.accountId, transactionId: event.transactionId);
    } else if (event is UpdateAmount) {
      await updateTransactionUseCase.updateAmount(
          newAmount: event.amount, transactionId: event.transactionId);
    } else if (event is UpdateCategoryID) {
      await updateTransactionUseCase.updateCategoryId(
          categoryId: event.categoryId, transactionId: event.transactionId);
    } else if (event is UpdateDescription) {
      await updateTransactionUseCase.updateDescription(
          description: event.description, transactionId: event.transactionId);
    } else if (event is UpdateRecurrence) {
      await updateTransactionUseCase.updateRecurrence(
          recurrence: event.recurrence, transactionId: event.transactionId);
    } else if (event is UpdateTags) {
      await updateTransactionUseCase.updateTags(
          tags: event.tags, transactionId: event.transactionId);
    } else if (event is Delete) {
      await deleteTransactionUseCase.delete(itemID: event.transactionId!);
    }
  }
}

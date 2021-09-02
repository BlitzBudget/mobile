import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import '../../../../domain/entities/category/category_type.dart';
import '../../../../domain/entities/transaction/recurrence.dart';
import '../../../../domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart'
    as update_recurring_transaction_use_case;

part 'recurring_transaction_event.dart';
part 'recurring_transaction_state.dart';

class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  RecurringTransactionBloc({required this.updateRecurringTransactionUseCase})
      : super(Empty());

  final update_recurring_transaction_use_case.UpdateRecurringTransactionUseCase
      updateRecurringTransactionUseCase;

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
      await updateRecurringTransactionUseCase.update(
          updateRecurringTransaction: updateRecurringTransaction);
    } else if (event is UpdateAccountID) {
      await updateRecurringTransactionUseCase.updateAccountId(
          accountId: event.accountId);
    } else if (event is UpdateAmount) {
      await updateRecurringTransactionUseCase.updateAmount(
          newAmount: event.amount);
    } else if (event is UpdateCategoryID) {
      await updateRecurringTransactionUseCase.updateCategoryId(
          categoryId: event.category);
    } else if (event is UpdateDescription) {
      await updateRecurringTransactionUseCase.updateDescription(
          description: event.description);
    } else if (event is UpdateRecurrence) {
      await updateRecurringTransactionUseCase.updateRecurrence(
          recurrence: event.recurrence);
    } else if (event is UpdateTags) {
      await updateRecurringTransactionUseCase.updateTags(tags: event.tags);
    }
  }
}

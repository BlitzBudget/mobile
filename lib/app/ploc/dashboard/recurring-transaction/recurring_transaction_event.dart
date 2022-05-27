part of 'recurring_transaction_bloc.dart';

abstract class RecurringTransactionEvent extends Equatable {
  const RecurringTransactionEvent(
      {this.recurringTransactionId,
      this.walletId,
      this.amount,
      this.description,
      this.accountId,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.category,
      this.tags});

  final String? recurringTransactionId;
  final String? walletId;
  final double? amount;
  final String? description;
  final String? accountId;
  final Recurrence? recurrence;
  final CategoryType? categoryType;
  final String? categoryName;
  final String? category;
  final List<String>? tags;

  @override
  List<Object> get props => [];
}

class UpdateAmount extends RecurringTransactionEvent {
  const UpdateAmount(
      {required final double? amount,
      required final String? recurringTransactionId})
      : super(amount: amount, recurringTransactionId: recurringTransactionId);
}

class UpdateDescription extends RecurringTransactionEvent {
  const UpdateDescription(
      {required final String? description,
      required final String? recurringTransactionId})
      : super(
            description: description,
            recurringTransactionId: recurringTransactionId);
}

class UpdateAccountID extends RecurringTransactionEvent {
  const UpdateAccountID(
      {required final String? accountId,
      required final String? recurringTransactionId})
      : super(
            accountId: accountId,
            recurringTransactionId: recurringTransactionId);
}

class UpdateCategoryID extends RecurringTransactionEvent {
  const UpdateCategoryID(
      {required final String? categoryID,
      required final String? recurringTransactionId})
      : super(
            category: categoryID,
            recurringTransactionId: recurringTransactionId);
}

class UpdateRecurrence extends RecurringTransactionEvent {
  const UpdateRecurrence(
      {required final Recurrence? recurrence,
      required final String? recurringTransactionId})
      : super(
            recurrence: recurrence,
            recurringTransactionId: recurringTransactionId);
}

class UpdateTags extends RecurringTransactionEvent {
  const UpdateTags(
      {required final List<String>? tags,
      required final String? recurringTransactionId})
      : super(tags: tags, recurringTransactionId: recurringTransactionId);
}

class Delete extends RecurringTransactionEvent {
  const Delete({required final String itemID})
      : super(recurringTransactionId: itemID);
}

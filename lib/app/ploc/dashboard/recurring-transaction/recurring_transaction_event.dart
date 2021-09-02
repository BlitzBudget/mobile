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

class Update extends RecurringTransactionEvent {
  const Update(
    final String? recurringTransactionId,
    final String? walletId,
    final double? amount,
    final String? description,
    final String? accountId,
    final Recurrence? recurrence,
    final CategoryType? categoryType,
    final String? categoryName,
    final String? categoryID,
    final List<String>? tags,
  ) : super(
            recurringTransactionId: recurringTransactionId,
            walletId: walletId,
            amount: amount,
            description: description,
            accountId: accountId,
            recurrence: recurrence,
            categoryType: categoryType,
            categoryName: categoryName,
            category: categoryID,
            tags: tags);
}

class UpdateAmount extends RecurringTransactionEvent {
  const UpdateAmount(final double? amount, final String? recurringTransactionId)
      : super(amount: amount, recurringTransactionId: recurringTransactionId);
}

class UpdateDescription extends RecurringTransactionEvent {
  const UpdateDescription(
      final String? description, final String? recurringTransactionId)
      : super(
            description: description,
            recurringTransactionId: recurringTransactionId);
}

class UpdateAccountID extends RecurringTransactionEvent {
  const UpdateAccountID(
      final String? accountId, final String? recurringTransactionId)
      : super(
            accountId: accountId,
            recurringTransactionId: recurringTransactionId);
}

class UpdateCategoryID extends RecurringTransactionEvent {
  const UpdateCategoryID(
      final String? categoryID, final String? recurringTransactionId)
      : super(
            category: categoryID,
            recurringTransactionId: recurringTransactionId);
}

class UpdateRecurrence extends RecurringTransactionEvent {
  const UpdateRecurrence(
      final Recurrence? recurrence, final String? recurringTransactionId)
      : super(
            recurrence: recurrence,
            recurringTransactionId: recurringTransactionId);
}

class UpdateTags extends RecurringTransactionEvent {
  const UpdateTags(
      final List<String>? tags, final String? recurringTransactionId)
      : super(tags: tags, recurringTransactionId: recurringTransactionId);
}

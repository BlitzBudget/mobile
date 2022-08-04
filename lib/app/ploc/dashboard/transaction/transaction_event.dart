part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent(
      {this.transactionId,
      this.walletId,
      this.amount,
      this.description,
      this.accountId,
      this.dateMeantFor,
      this.categoryId,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

  final String? transactionId;
  final String? walletId;
  final double? amount;
  final String? description;
  final String? accountId;
  final String? dateMeantFor;
  final String? categoryId;
  final Recurrence? recurrence;
  final CategoryType? categoryType;
  final String? categoryName;
  final List<String>? tags;

  @override
  List<Object> get props => [];
}

class Add extends TransactionEvent {
  const Add({
    final String? transactionId,
    final String? walletId,
    required final double? amount,
    required final String? description,
    final String? categoryId,
    final List<String>? tags,
  }) : super(
            transactionId: transactionId,
            walletId: walletId,
            amount: amount,
            description: description,
            categoryId: categoryId,
            tags: tags);
}

class Delete extends TransactionEvent {
  const Delete({required final String? transactionId})
      : super(transactionId: transactionId);
}

class Fetch extends TransactionEvent {
  const Fetch() : super();
}

class UpdateAmount extends TransactionEvent {
  const UpdateAmount(
      {required final double? amount, required final String? transactionId})
      : super(amount: amount, transactionId: transactionId);
}

class UpdateDescription extends TransactionEvent {
  const UpdateDescription(
      {required final String? description,
      required final String? transactionId})
      : super(description: description, transactionId: transactionId);
}

class UpdateAccountID extends TransactionEvent {
  const UpdateAccountID(
      {required final String? accountId, required final String? transactionId})
      : super(accountId: accountId, transactionId: transactionId);
}

class UpdateCategoryID extends TransactionEvent {
  const UpdateCategoryID(
      {required final String? categoryID, required final String? transactionId})
      : super(categoryId: categoryID, transactionId: transactionId);
}

class UpdateRecurrence extends TransactionEvent {
  const UpdateRecurrence(
      {required final Recurrence? recurrence,
      required final String? transactionId})
      : super(recurrence: recurrence, transactionId: transactionId);
}

class UpdateTags extends TransactionEvent {
  const UpdateTags(
      {required final List<String>? tags, required final String? transactionId})
      : super(tags: tags, transactionId: transactionId);
}

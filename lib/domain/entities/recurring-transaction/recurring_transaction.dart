import 'package:equatable/equatable.dart';

import '../category/category_type.dart';
import '../transaction/recurrence.dart' show Recurrence;

class RecurringTransaction extends Equatable {
  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  const RecurringTransaction(
      {this.category,
      this.walletId,
      this.amount,
      this.accountId,
      this.recurringTransactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags,
      this.nextScheduled,
      this.creationDate});

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
  final String? nextScheduled;
  final String? creationDate;

  @override
  List<Object?> get props => [
        recurringTransactionId,
        walletId,
        amount,
        description,
        accountId,
        recurrence,
        categoryType,
        categoryName,
        category,
        tags,
        nextScheduled
      ];
}

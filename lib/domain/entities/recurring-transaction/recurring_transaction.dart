import 'package:equatable/equatable.dart';

import '../category/category_type.dart';
import '../transaction/recurrence.dart' show Recurrence;

class RecurringTransaction extends Equatable {
  final String recurringTransactionId;
  final String walletId;
  final double amount;
  final String description;
  final String account;
  final Recurrence recurrence;
  final CategoryType categoryType;
  final String categoryName;
  final String category;
  final List<String> tags;

  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  RecurringTransaction(
      {this.category,
      this.walletId,
      this.amount,
      this.account,
      this.recurringTransactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

  @override
  List<Object> get props => [
        recurringTransactionId,
        walletId,
        amount,
        description,
        account,
        recurrence,
        categoryType,
        categoryName,
        category,
        tags
      ];
}

import 'package:equatable/equatable.dart';

import '../category/category_type.dart';
import 'recurrence.dart';

class Transaction extends Equatable {
  /// Optional Transactions id, description, recurrence, category type, category name and tags
  const Transaction(
      {this.walletId,
      this.amount,
      this.accountId,
      this.dateMeantFor,
      this.categoryId,
      this.transactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

  final String transactionId;
  final String walletId;
  final double amount;
  final String description;
  final String accountId;
  final String dateMeantFor;
  final String categoryId;
  final Recurrence recurrence;
  final CategoryType categoryType;
  final String categoryName;
  final List<String> tags;

  @override
  List<Object> get props => [
        transactionId,
        walletId,
        amount,
        description,
        accountId,
        dateMeantFor,
        categoryId,
        recurrence,
        categoryType,
        categoryName,
        tags
      ];
}

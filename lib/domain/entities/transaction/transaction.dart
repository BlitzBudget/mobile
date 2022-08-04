import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  /// Optional Transactions id, description, recurrence, category type, category name and tags
  const Transaction(
      {this.walletId,
      this.amount,
      this.categoryId,
      this.transactionId,
      this.description,
      this.tags});

  final String? transactionId;
  final String? walletId;
  final double? amount;
  final String? description;
  final String? categoryId;
  final List<String>? tags;

  @override
  List<Object?> get props =>
      [transactionId, walletId, amount, description, categoryId, tags];
}

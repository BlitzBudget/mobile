import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

class TransactionModel extends Transaction {
  /// Optional Transactions id, description, recurrence, category type, category name and tags
  const TransactionModel(
      {String? transactionId,
      String? walletId,
      double? amount,
      String? description,
      String? categoryId,
      List<String>? tags})
      : super(
            walletId: walletId,
            amount: amount,
            categoryId: categoryId,
            transactionId: transactionId,
            description: description,
            tags: tags);

  /// Map JSON transactions to List of object
  factory TransactionModel.fromJSON(Map<String, dynamic> transaction) {
    final tags =
        transaction['tags']?.map<String>(parseDynamicAsString)?.toList();
    return TransactionModel(
        transactionId: parseDynamicAsString(transaction['transactionId']),
        walletId: parseDynamicAsString(transaction['walletId']),
        amount: parseDynamicAsDouble(transaction['amount']),
        description: parseDynamicAsString(transaction['description']),
        categoryId: parseDynamicAsString(transaction['category']),
        tags: tags);
  }

  /// Transaction to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'pk': walletId,
        'sk': transactionId,
        'amount': amount,
        'description': description,
        'tags': tags,
        'category': categoryId,
      };
}

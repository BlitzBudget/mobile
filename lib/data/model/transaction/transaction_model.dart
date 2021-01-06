import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

class TransactionModel extends Transaction {
  /// Optional Transactions id, description, recurrence, category type, category name and tags
  TransactionModel(
      {String transactionId,
      String walletId,
      double amount,
      String description,
      String accountId,
      String dateMeantFor,
      String categoryId,
      Recurrence recurrence,
      CategoryType categoryType,
      String categoryName,
      List<String> tags})
      : super(
            walletId: walletId,
            amount: amount,
            accountId: accountId,
            dateMeantFor: dateMeantFor,
            categoryId: categoryId,
            transactionId: transactionId,
            description: description,
            recurrence: recurrence,
            categoryType: categoryType,
            categoryName: categoryName,
            tags: tags);

  /// Map JSON transactions to List of object
  factory TransactionModel.fromJSON(Map<String, dynamic> transaction) {
    final tags = (transaction['tags'] as List)
        ?.map((dynamic item) => item as String)
        ?.toList();
    return TransactionModel(
        transactionId: parseDynamicAsString(transaction['transactionId']),
        walletId: parseDynamicAsString(transaction['walletId']),
        amount: parseDynamicAsDouble(transaction['amount']),
        description: parseDynamicAsString(transaction['description']),
        accountId: parseDynamicAsString(transaction['account']),
        dateMeantFor: parseDynamicAsString(transaction['date_meant_for']),
        categoryId: parseDynamicAsString(transaction['category']),
        recurrence: parseDynamicToRecurrence(transaction['recurrence']),
        categoryType: parseDynamicToCategoryType(transaction['category_type']),
        categoryName: parseDynamicAsString(transaction['category_name']),
        tags: tags);
  }

  /// Transaction to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'transactionId': transactionId,
        'amount': amount,
        'recurrence': recurrence,
        'account': accountId,
        'dateMeantFor': dateMeantFor,
        'description': description,
        'tags': tags,
        'category': categoryId,
        'categoryType': categoryType,
        'categoryName': categoryName
      };
}

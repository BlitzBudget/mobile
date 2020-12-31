import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

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
    return TransactionModel(
        transactionId: parseDynamicToString(transaction['transactionId']),
        walletId: parseDynamicToString(transaction['walletId']),
        amount: parseDynamicToDouble(transaction['amount']),
        description: parseDynamicToString(transaction['description']),
        accountId: parseDynamicToString(transaction['account']),
        dateMeantFor: parseDynamicToString(transaction['date_meant_for']),
        categoryId: parseDynamicToString(transaction['category']),
        recurrence: parseDynamicToRecurrence(transaction['recurrence']),
        categoryType: parseDynamicToCategoryType(transaction['category_type']),
        categoryName: parseDynamicToString(transaction['category_name']),
        tags: transaction['tags'] as List<String>);
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

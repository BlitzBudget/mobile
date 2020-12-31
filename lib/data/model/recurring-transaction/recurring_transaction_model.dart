import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

class RecurringTransactionModel extends RecurringTransaction {
  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  RecurringTransactionModel({
    String recurringTransactionId,
    String walletId,
    double amount,
    String description,
    String accountId,
    Recurrence recurrence,
    CategoryType categoryType,
    String categoryName,
    String category,
    List<String> tags,
  }) : super(
            walletId: walletId,
            amount: amount,
            accountId: accountId,
            recurringTransactionId: recurringTransactionId,
            description: description,
            recurrence: recurrence,
            categoryType: categoryType,
            categoryName: categoryName,
            tags: tags);

  /// Map JSON recurring transactions to List of object
  factory RecurringTransactionModel.fromJSON(
      Map<String, dynamic> recurringTransaction) {
    return RecurringTransactionModel(
        recurringTransactionId: parseDynamicToString(
            recurringTransaction['recurringTransactionsId']),
        walletId: parseDynamicToString(recurringTransaction['walletId']),
        amount: parseDynamicToDouble(recurringTransaction['amount']),
        description: parseDynamicToString(recurringTransaction['description']),
        accountId: parseDynamicToString(recurringTransaction['account']),
        recurrence:
            parseDynamicToRecurrence(recurringTransaction['recurrence']),
        categoryType:
            parseDynamicToCategoryType(recurringTransaction['category_type']),
        categoryName:
            parseDynamicToString(recurringTransaction['category_name']),
        tags: recurringTransaction['tags'] as List<String>,
        category: parseDynamicToString(recurringTransaction['category']));
  }

  /// Recurring Transaction to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'recurringTransactionId': recurringTransactionId,
        'amount': amount,
        'recurrence': recurrence,
        'account': accountId,
        'description': description,
        'tags': tags,
        'categoryType': categoryType,
        'categoryName': categoryName
      };
}

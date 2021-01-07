import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';

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
            account: accountId,
            recurringTransactionId: recurringTransactionId,
            description: description,
            recurrence: recurrence,
            categoryType: categoryType,
            categoryName: categoryName,
            tags: tags);

  /// Map JSON recurring transactions to List of object
  factory RecurringTransactionModel.fromJSON(
      Map<String, dynamic> recurringTransaction) {
    final tags = (recurringTransaction['tags'] as List)
        ?.map((dynamic item) => item as String)
        ?.toList();
    return RecurringTransactionModel(
        recurringTransactionId: parseDynamicAsString(
            recurringTransaction['recurringTransactionsId']),
        walletId: parseDynamicAsString(recurringTransaction['walletId']),
        amount: parseDynamicAsDouble(recurringTransaction['amount']),
        description: parseDynamicAsString(recurringTransaction['description']),
        accountId: parseDynamicAsString(recurringTransaction['account']),
        recurrence:
            parseDynamicAsRecurrence(recurringTransaction['recurrence']),
        categoryType:
            parseDynamicAsCategoryType(recurringTransaction['category_type']),
        categoryName:
            parseDynamicAsString(recurringTransaction['category_name']),
        tags: tags,
        category: parseDynamicAsString(recurringTransaction['category']));
  }

  /// Recurring Transaction to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'recurringTransactionId': recurringTransactionId,
        'amount': amount,
        'recurrence': recurrence.name,
        'account': account,
        'description': description,
        'tags': tags,
        'categoryType': categoryType.name,
        'categoryName': categoryName
      };
}

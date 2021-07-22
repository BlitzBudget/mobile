import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

class RecurringTransactionModel extends RecurringTransaction {
  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  const RecurringTransactionModel(
      {String? recurringTransactionId,
      String? walletId,
      double? amount,
      String? description,
      String? accountId,
      Recurrence? recurrence,
      CategoryType? categoryType,
      String? categoryName,
      String? category,
      List<String>? tags,
      String? nextScheduled,
      String? creationDate})
      : super(
            walletId: walletId,
            amount: amount,
            accountId: accountId,
            recurringTransactionId: recurringTransactionId,
            description: description,
            recurrence: recurrence,
            category: category,
            categoryType: categoryType,
            categoryName: categoryName,
            tags: tags,
            nextScheduled: nextScheduled,
            creationDate: creationDate);

  /// Map JSON recurring transactions to List of object
  factory RecurringTransactionModel.fromJSON(
      Map<String, dynamic> recurringTransaction) {
    final tags = (recurringTransaction['tags'])
        ?.map<String>(parseDynamicAsString)
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
        category: parseDynamicAsString(recurringTransaction['category']),
        nextScheduled:
            parseDynamicAsString(recurringTransaction['next_scheduled']),
        creationDate:
            parseDynamicAsString(recurringTransaction['creation_date']));
  }

  /// Recurring Transaction to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'recurringTransactionId': recurringTransactionId,
        'amount': amount,
        'recurrence': recurrence.name,
        'account': accountId,
        'description': description,
        'tags': tags,
        'categoryType': categoryType.name,
        'categoryName': categoryName,
        'nextScheduled': nextScheduled,
        'creationDate': creationDate
      };
}

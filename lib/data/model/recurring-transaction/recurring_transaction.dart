import '../category/category_type.dart';
import '../transaction/recurrence.dart' show Recurrence;

class RecurringTransaction {
  String recurringTransactionId;
  String walletId;
  double amount;
  String description;
  String accountId;
  Recurrence recurrence;
  CategoryType categoryType;
  String categoryName;
  String category;
  List<String> tags;

  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  RecurringTransaction(
      {this.walletId,
      this.amount,
      this.accountId,
      this.recurringTransactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

  /// Map JSON recurring transactions to List of object
  factory RecurringTransaction.fromJSON(
      Map<String, dynamic> recurringTransaction) {
    return RecurringTransaction(
        recurringTransactionId: recurringTransaction['recurringTransactionsId'],
        walletId: recurringTransaction['walletId'],
        amount: recurringTransaction['amount'],
        description: recurringTransaction['description'],
        accountId: recurringTransaction['account'],
        recurrence: recurringTransaction['recurrence'],
        categoryType: recurringTransaction['category_type'],
        categoryName: recurringTransaction['category_name'],
        tags: recurringTransaction['tags'],
        category: recurringTransaction['category']);
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

import '../transaction/recurrence.dart';
import '../category/category_type.dart';

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
  RecurringTransaction(this.walletId, this.amount, this.accountId,
      {this.recurringTransactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

  /// Map JSON recurring transactions to List of object
  RecurringTransaction.map(dynamic recurringTransaction) {
    this.recurringTransactionId =
        recurringTransaction['recurringTransactionsId'];
    this.walletId = recurringTransaction['walletId'];
    this.amount = recurringTransaction['amount'];
    this.description = recurringTransaction['description'];
    this.accountId = recurringTransaction['account'];
    this.recurrence = recurringTransaction['recurrence'];
    this.categoryType = recurringTransaction['category_type'];
    this.categoryName = recurringTransaction['category_name'];
    this.tags = recurringTransaction['tags'];
    this.category = recurringTransaction['category'];
  }

  /// Recurring Transaction to JSON
  Map<String, dynamic> toJSON() => {
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

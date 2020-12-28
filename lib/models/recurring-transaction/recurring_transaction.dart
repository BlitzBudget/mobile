import '../transaction/recurrence.dart';
import '../category/category_type.dart';

class RecurringTransaction {
  String recurringTransactionId;
  String walletId;
  Double amount;
  String description;
  String accountId;
  Recurrence recurrence;
  CategoryType categoryType;
  String categoryName;
  List<String> tags;

  /// Optional Recurring Transactions id, description, recurrence, category type, category name and tags
  RecurringTransaction(this.walletId, this.amount, this.accountId,
                       {this.recurringTransactionId,
      this.description,
      this.recurrence,
      this.categoryType,
      this.categoryName,
      this.tags});

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

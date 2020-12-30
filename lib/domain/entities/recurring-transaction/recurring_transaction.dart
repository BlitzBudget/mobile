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
}

import 'recurrence.dart';
import '../category/category_type.dart';

class Transaction {
  String transactionId;
  String walletId;
  double amount;
  String description;
  String accountId;
  String dateMeantFor;
  String categoryId;
  Recurrence recurrence;
  CategoryType categoryType;
  String categoryName;
  List<String> tags;

  /// Optional Transactions id, description, recurrence, category type, category name and tags
  Transaction(this.walletId, this.amount, this.accountId, this.dateMeantFor,
      this.categoryId,
      {this.transactionId,
      this.description = '',
      this.recurrence = Recurrence.never,
      this.categoryType,
      this.categoryName,
      this.tags});
}

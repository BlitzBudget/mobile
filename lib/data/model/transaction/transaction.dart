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

  /// Map JSON transactions to List of object
  factory Transaction.fromJSON(Map<String, dynamic> transaction) {
    this.transactionId = transaction['transactionId'];
    this.walletId = transaction['walletId'];
    this.amount = transaction['amount'];
    this.description = transaction['description'];
    this.accountId = transaction['account'];
    this.dateMeantFor = transaction['date_meant_for'];
    this.categoryId = transaction['category'];
    this.recurrence = transaction['recurrence'];
    this.tags = transaction['tags'];
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

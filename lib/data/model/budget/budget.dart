import '../category/category_type.dart';

class Budget {
  String budgetId;
  String walletId;
  double planned;
  double used;
  String dateMeantFor;
  String category;
  CategoryType categoryType;

  // Optional category type and Budget id fields
  Budget(this.walletId, this.planned, this.dateMeantFor, this.category,
      {this.categoryType, this.budgetId});

  /// Map JSON Budget to List of object
  Budget.map(dynamic budget) {
    this.budgetId = budget['budgetId'];
    this.walletId = budget['walletId'];
    this.planned = budget['planned'];
    this.used = budget['used'];
    this.category = budget['category'];
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'budgetId': budgetId,
        'dateMeantFor': dateMeantFor,
        'planned': planned,
        'category': category,
        'categoryType': categoryType
      };
}

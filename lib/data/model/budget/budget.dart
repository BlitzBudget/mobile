import '../category/category_type.dart' show CategoryType;

class Budget {
  String budgetId;
  String walletId;
  double planned;
  double used;
  String dateMeantFor;
  String category;
  CategoryType categoryType;

  // Optional category type and Budget id fields
  Budget(
      {this.walletId,
      this.planned,
      this.dateMeantFor,
      this.category,
      this.categoryType,
      this.budgetId});

  /// Map JSON Budget to List of object
  factory Budget.fromJSON(Map<String, dynamic> budget) {
    return Budget(
        budgetId: budget['budgetId'],
        walletId: budget['walletId'],
        planned: budget['planned'],
        used: budget['used'],
        category: budget['category']);
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'budgetId': budgetId,
        'dateMeantFor': dateMeantFor,
        'planned': planned,
        'category': category,
        'categoryType': categoryType
      };
}

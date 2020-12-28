import '../category/category_type.dart';

class Budget {
  String budgetId;
  String walletId;
  double planned;
  String dateMeantFor;
  String category;
  CategoryType categoryType;

  // Optional category type and Budget id fields
  Budget(this.walletId, this.planned, this.dateMeantFor, this.category,
      {this.categoryType, this.budgetId});

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

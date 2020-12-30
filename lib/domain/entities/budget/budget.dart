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
}

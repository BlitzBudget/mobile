enum CategoryType { income, expense }

extension CategoryTypeExtension on CategoryType? {
  String? get name {
    switch (this) {
      case CategoryType.income:
        return 'Income';
      case CategoryType.expense:
        return 'Expense';
      default:
        return null;
    }
  }
}

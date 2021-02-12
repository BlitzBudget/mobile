import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

void main() {
  group('CategoryType', () {
    test('Extension to convert to String', () async {
      final income = CategoryType.income.name;
      final expense = CategoryType.expense.name;
      expect(income, equals('Income'));
      expect(expense, equals('Expense'));
    });
  });
}

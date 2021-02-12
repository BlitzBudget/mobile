import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final dateModelAsString = fixture('models/get/date/date_model.json');
  final dateModelAsJSON = jsonDecode(dateModelAsString);
  final dateModel = DateModel(
      walletId: dateModelAsJSON['walletId'],
      dateId: dateModelAsJSON['dateId'],
      expenseTotal: parseDynamicAsDouble(dateModelAsJSON['expense_total']),
      incomeTotal: parseDynamicAsDouble(dateModelAsJSON['income_total']),
      balance: parseDynamicAsDouble(dateModelAsJSON['balance']));
  test(
    'Should be a subclass of BankAccount entity',
    () async {
      // assert
      expect(dateModel, isA<Date>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final dateModelConverted = DateModel.fromJSON(dateModelAsJSON);
      expect(dateModelConverted, equals(dateModel));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';

void main() {
  group('AccountType', () {
    test('Extension to convert to String', () async {
      final asset = AccountType.asset.name;
      final debt = AccountType.debt.name;
      expect(asset, equals('ASSET'));
      expect(debt, equals('DEBT'));
    });
  });
}

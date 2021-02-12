import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';

void main() {
  group('TargetType', () {
    test('Extension to convert to String', () async {
      final account = TargetType.account.name;
      final wallet = TargetType.wallet.name;
      expect(account, equals('Account'));
      expect(wallet, equals('Wallet'));
    });
  });
}

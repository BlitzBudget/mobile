import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

void main() {
  group('Recurrence', () {
    test('Extension to convert to String', () async {
      final biMonthly = Recurrence.biMonthly.name;
      final monthly = Recurrence.monthly.name;
      final never = Recurrence.never.name;
      final weekly = Recurrence.weekly.name;
      expect(biMonthly, equals('BI-MONTHLY'));
      expect(monthly, equals('MONTHLY'));
      expect(never, equals('NEVER'));
      expect(weekly, equals('WEEKLY'));
    });
  });
}

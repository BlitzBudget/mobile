import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';

void main() {
  group('GoalType', () {
    test('Extension to convert to String', () async {
      final buyACar = GoalType.buyACar.name;
      final buyAHome = GoalType.buyAHome.name;
      final creditCard = GoalType.creditCard.name;
      final customGoal = GoalType.customGoal.name;
      final emergencyFund = GoalType.emergencyFund.name;
      final improveMyHome = GoalType.improveMyHome.name;
      final payALoan = GoalType.payLoan.name;
      final planATrip = GoalType.planATrip.name;
      final retirement = GoalType.retirement.name;
      final university = GoalType.university.name;
      expect(buyACar, equals('BuyACar'));
      expect(buyAHome, equals('BuyAHome'));
      expect(creditCard, equals('CreditCard'));
      expect(customGoal, equals('CustomGoal'));
      expect(emergencyFund, equals('EmergencyFund'));
      expect(improveMyHome, equals('ImproveMyHome'));
      expect(payALoan, equals('PayLoan'));
      expect(planATrip, equals('PlanATrip'));
      expect(retirement, equals('Retirement'));
      expect(university, equals('University'));
    });
  });
}

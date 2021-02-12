enum GoalType {
  emergencyFund,
  creditCard,
  buyACar,
  buyAHome,
  customGoal,
  improveMyHome,
  payLoan,
  planATrip,
  retirement,
  university
}

extension GoalTypeExtension on GoalType {
  String get name {
    switch (this) {
      case GoalType.emergencyFund:
        return 'EmergencyFund';
      case GoalType.creditCard:
        return 'CreditCard';
      case GoalType.buyACar:
        return 'BuyACar';
      case GoalType.buyAHome:
        return 'BuyAHome';
      case GoalType.customGoal:
        return 'CustomGoal';
      case GoalType.improveMyHome:
        return 'ImproveMyHome';
      case GoalType.payLoan:
        return 'PayLoan';
      case GoalType.planATrip:
        return 'PlanATrip';
      case GoalType.retirement:
        return 'Retirement';
      case GoalType.university:
        return 'University';
      default:
        return null;
    }
  }
}

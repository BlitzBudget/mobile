import 'account_type.dart';

enum AccountSubType {
  savingsAccount,
  currentAccount,
  cash,
  assets,
  creditCard,
  liability
}

extension AccountSubTypeExtension on AccountSubType? {
  /// Account Sub Type conversion to String name
  String? get name {
    switch (this) {
      case AccountSubType.savingsAccount:
        return 'Savings Account';
      case AccountSubType.currentAccount:
        return 'Current Account';
      case AccountSubType.cash:
        return 'Cash';
      case AccountSubType.assets:
        return 'Assets';
      case AccountSubType.creditCard:
        return 'Credit Card';
      case AccountSubType.liability:
        return 'Liability';
      default:
        return null;
    }
  }

  /// Account Sub Type conversion to Account Type
  String? get accountType {
    switch (this) {
      case AccountSubType.savingsAccount:
        return AccountType.asset.name;
      case AccountSubType.currentAccount:
        return AccountType.asset.name;
      case AccountSubType.cash:
        return AccountType.asset.name;
      case AccountSubType.assets:
        return AccountType.asset.name;
      case AccountSubType.creditCard:
        return AccountType.debt.name;
      case AccountSubType.liability:
        return AccountType.debt.name;
      default:
        return null;
    }
  }
}

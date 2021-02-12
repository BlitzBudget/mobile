import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';

void main() {
  group('AccountSubType', () {
    test('Extension to convert to String', () async {
      final assets = AccountSubType.assets.name;
      final cash = AccountSubType.cash.name;
      final creditCard = AccountSubType.creditCard.name;
      final currentAccount = AccountSubType.currentAccount.name;
      final liability = AccountSubType.liability.name;
      final savingsAccount = AccountSubType.savingsAccount.name;
      expect(assets, equals('Assets'));
      expect(cash, equals('Cash'));
      expect(creditCard, equals('Credit Card'));
      expect(currentAccount, equals('Current Account'));
      expect(liability, equals('Liability'));
      expect(savingsAccount, equals('Savings Account'));
    });

    test('Extension to convert to AccountType String', () async {
      final assetsAccountType = AccountSubType.assets.accountType;
      final cashAccountType = AccountSubType.cash.accountType;
      final creditCardAccountType = AccountSubType.creditCard.accountType;
      final currentAccountAccountType =
          AccountSubType.currentAccount.accountType;
      final liabilityAccountType = AccountSubType.liability.accountType;
      final savingsAccountAccountType =
          AccountSubType.savingsAccount.accountType;
      expect(assetsAccountType, equals(AccountType.asset.name));
      expect(cashAccountType, equals(AccountType.asset.name));
      expect(creditCardAccountType, equals(AccountType.debt.name));
      expect(currentAccountAccountType, equals(AccountType.asset.name));
      expect(liabilityAccountType, equals(AccountType.debt.name));
      expect(savingsAccountAccountType, equals(AccountType.asset.name));
    });
  });
}

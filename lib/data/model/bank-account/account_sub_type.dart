import 'account_type.dart';

class AccountSubType {
  const AccountSubType(String val);

  static const AccountSubType savingsAccount =
      AccountSubType('Savings Account');
  static const AccountSubType currentAccount =
      AccountSubType('Current Account');
  static const AccountSubType cash = AccountSubType('Cash');
  static const AccountSubType assets = AccountSubType('Assets');
  static const AccountSubType creditCard = AccountSubType('Credit Card');
  static const AccountSubType liability = AccountSubType('Liability');

  /// GET Account Subtype vs Account type relationship
  Map<AccountSubType, AccountType> toJSON() => <AccountSubType, AccountType>{
        savingsAccount: AccountType.ASSET,
        currentAccount: AccountType.ASSET,
        cash: AccountType.ASSET,
        assets: AccountType.ASSET,
        creditCard: AccountType.ASSET,
        liability: AccountType.ASSET
      };
}

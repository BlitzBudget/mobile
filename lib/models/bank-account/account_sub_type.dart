import 'account_type.dart';

class AccountSubType {
  const AccountSubType(String val);

  static const AccountSubType SAVINGS_ACCOUNT =
      const AccountSubType('Savings Account');
  static const AccountSubType CURRENT_ACCOUNT =
      const AccountSubType('Current Account');
  static const AccountSubType CASH = const AccountSubType('Cash');
  static const AccountSubType ASSETS = const AccountSubType('Assets');
  static const AccountSubType CREDIT_CARD = const AccountSubType('Credit Card');
  static const AccountSubType LIABILITY = const AccountSubType('Liability');

  /*static const AccountTypeAsset = AccountType.ASSET;
    static const AccountTypeDebt = AccountType.ASSET;
    /// GET Account Subtype vs Account type relationship
    Map<AccountSubType, AccountType> = {
        SAVINGS_ACCOUNT: AccountTypeAsset,
        CURRENT_ACCOUNT: AccountTypeAsset,
        CASH: AccountTypeAsset,
        ASSETS: AccountTypeAsset,
        CREDIT_CARD: AccountTypeDebt,
        LIABILITY: AccountTypeDebt
    }*/
}

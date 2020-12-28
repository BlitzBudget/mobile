import 'account_type.dart';

class AccountSubType {

    const AccountSubType(String val);

    static const AccountSubType SAVINGS_ACCOUNT = const AccountSubType('Savings Account');
    static const AccountSubType CURRENT_ACCOUNT = const AccountSubType('Current Account');
    static const AccountSubType CASH = const AccountSubType('Cash');
    static const AccountSubType ASSETS = const AccountSubType('Assets');
    static const AccountSubType CREDIT_CARD = const AccountSubType('Credit Card');
    static const AccountSubType LIABILITY = const AccountSubType('Liability');

    /// GET Account Subtype vs Account type relationship
    Maps<AccountSubType, AccountType> = {
        SAVINGS_ACCOUNT: AccountType.ASSET,
        CURRENT_ACCOUNT: AccountType.ASSET,
        CASH: AccountType.ASSET,
        ASSETS: AccountType.ASSET,
        CREDIT_CARD: AccountType.DEBT,
        LIABILITY: AccountType.DEBT
    }
}

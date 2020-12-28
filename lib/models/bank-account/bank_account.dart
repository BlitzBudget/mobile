import 'account_type.dart';
import 'account_sub_type.dart';

class BankAccount {
  String accountId;
  String walletId;
  String primaryWallet;
  double accountBalance;
  bool linked;
  bool selectedAccount;
  AccountType accountType;
  AccountSubType accountSubType;
  String bankAccountName;

  /// Optional account id, linked, selected account, account type, bank account name
  BankAccount(this.walletId, this.accountBalance,
      {this.accountId,
      this.linked,
      this.selectedAccount,
      this.accountType,
      this.bankAccountName});

  /// Bank Account to JSON
  Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'accountId': accountId,
        'primaryWallet': primaryWallet,
        'selectedAccount': selectedAccount,
        'accountType': accountType,
        'accountSubType': accountSubType,
        'accountBalance': accountBalance,
        'bankAccountName': bankAccountName,
        'linked': linked
      };
}

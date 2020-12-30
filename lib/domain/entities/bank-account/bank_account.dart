import 'account_sub_type.dart';
import 'account_type.dart';

class BankAccount {
  String accountId;
  String walletId;
  double accountBalance;
  bool linked;
  bool selectedAccount;
  AccountType accountType;
  AccountSubType accountSubType;
  String bankAccountName;

  /// Optional account id, linked, selected account, account type, bank account name
  BankAccount(
      {this.walletId,
      this.accountBalance,
      this.accountId,
      this.linked,
      this.selectedAccount,
      this.accountType,
      this.accountSubType,
      this.bankAccountName});
}

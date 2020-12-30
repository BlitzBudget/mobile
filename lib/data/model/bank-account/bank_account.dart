import 'account_sub_type.dart';
import 'account_type.dart';

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
  BankAccount(
      {this.walletId,
      this.accountBalance,
      this.accountId,
      this.linked,
      this.selectedAccount,
      this.accountType,
      this.bankAccountName});

  /// Map JSON BankAccount to List of object
  factory BankAccount.fromJSON(Map<String, dynamic> bankAccount) {
    return BankAccount(
        accountId: bankAccount['accountId'],
        walletId: bankAccount['walletId'],
        accountBalance: bankAccount['account_balance'],
        linked: bankAccount['linked'],
        selectedAccount: bankAccount['selected_account'],
        accountType: bankAccount['account_type'],
        accountSubType: bankAccount['account_sub_type'],
        bankAccountName: bankAccount['bank_account_name']);
  }

  /// Bank Account to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
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

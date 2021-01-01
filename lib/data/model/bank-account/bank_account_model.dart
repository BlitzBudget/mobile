import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

class BankAccountModel extends BankAccount {
  BankAccountModel(
      {String walletId,
      double accountBalance,
      String accountId,
      bool linked,
      bool selectedAccount,
      AccountType accountType,
      AccountSubType accountSubType,
      String bankAccountName})
      : super(
            walletId: walletId,
            accountBalance: accountBalance,
            accountId: accountId,
            linked: linked,
            selectedAccount: selectedAccount,
            accountType: accountType,
            accountSubType: accountSubType,
            bankAccountName: bankAccountName);

  /// Map JSON BankAccount to List of object
  factory BankAccountModel.fromJSON(Map<String, dynamic> bankAccount) {
    return BankAccountModel(
        accountId: parseDynamicToString(bankAccount['accountId']),
        walletId: parseDynamicToString(bankAccount['walletId']),
        accountBalance: parseDynamicToDouble(bankAccount['account_balance']),
        linked: parseDynamicToBool(bankAccount['linked']),
        selectedAccount: parseDynamicToBool(bankAccount['selected_account']),
        accountType: parseDynamicToAccountType(bankAccount['account_type']),
        accountSubType:
            parseDynamicToAccountSubType(bankAccount['account_sub_type']),
        bankAccountName:
            parseDynamicToString(bankAccount['bank_account_name']));
  }

  /// Bank Account to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'accountId': accountId,
        'selectedAccount': selectedAccount,
        'accountType': accountType,
        'accountSubType': accountSubType,
        'accountBalance': accountBalance,
        'bankAccountName': bankAccountName,
        'linked': linked
      };

  /// Parse dynamic to Account Type
  static AccountType parseDynamicToAccountType(dynamic obj) {
    if (obj is AccountType) {
      return obj;
    }
    return null;
  }

  /// Parse dynamic to Account Sub Type
  static AccountSubType parseDynamicToAccountSubType(dynamic obj) {
    if (obj is AccountSubType) {
      return obj;
    }
    return null;
  }
}

import 'package:mobile_blitzbudget/core/utils/utils.dart';
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
        accountId: parseDynamicAsString(bankAccount['accountId']),
        walletId: parseDynamicAsString(bankAccount['walletId']),
        accountBalance: parseDynamicAsDouble(bankAccount['account_balance']),
        linked: parseDynamicAsBool(bankAccount['linked']),
        selectedAccount: parseDynamicAsBool(bankAccount['selected_account']),
        accountType: parseDynamicAsAccountType(bankAccount['account_type']),
        accountSubType:
            parseDynamicAsAccountSubType(bankAccount['account_sub_type']),
        bankAccountName:
            parseDynamicAsString(bankAccount['bank_account_name']));
  }

  /// Bank Account to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'accountId': accountId,
        'selectedAccount': selectedAccount,
        'accountType': accountType.name,
        'accountSubType': accountSubType.name,
        'accountBalance': accountBalance,
        'bankAccountName': bankAccountName,
        'linked': linked
      };
}

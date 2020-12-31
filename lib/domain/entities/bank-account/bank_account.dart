import 'package:equatable/equatable.dart';

import 'account_sub_type.dart';
import 'account_type.dart';

class BankAccount extends Equatable {
  final String accountId;
  final String walletId;
  final double accountBalance;
  final bool linked;
  final bool selectedAccount;
  final AccountType accountType;
  final AccountSubType accountSubType;
  final String bankAccountName;

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

  @override
  List<Object> get props => [
        accountId,
        walletId,
        accountBalance,
        linked,
        selectedAccount,
        accountType,
        accountSubType,
        bankAccountName
      ];
}

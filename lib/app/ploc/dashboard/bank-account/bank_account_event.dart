part of 'bank_account_bloc.dart';

abstract class BankAccountEvent extends Equatable {
  const BankAccountEvent(
      {this.deleteItemId,
      this.accountId,
      this.walletId,
      this.linked,
      this.accountType,
      this.accountSubType,
      this.accountBalance,
      this.bankAccountName,
      this.selectedAccount});

  final double? accountBalance;
  final String? bankAccountName;
  final bool? selectedAccount;
  final String? deleteItemId;
  final String? accountId;
  final String? walletId;
  final bool? linked;
  final AccountType? accountType;
  final AccountSubType? accountSubType;

  @override
  List<Object> get props => [];
}

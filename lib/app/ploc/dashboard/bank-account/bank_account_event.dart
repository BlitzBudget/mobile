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

class Add extends BankAccountEvent {
  const Add(
      {final double? accountBalance,
      final String? bankAccountName,
      final bool? selectedAccount,
      final String? accountId,
      final String? walletId,
      final bool? linked,
      final AccountType? accountType,
      final AccountSubType? accountSubType})
      : super(
            accountBalance: accountBalance,
            bankAccountName: bankAccountName,
            selectedAccount: selectedAccount,
            accountId: accountId,
            walletId: walletId,
            linked: linked,
            accountType: accountType,
            accountSubType: accountSubType);
}

class Delete extends BankAccountEvent {
  const Delete({final String? deleteItemId})
      : super(deleteItemId: deleteItemId);
}

class UpdateAccountBalance extends BankAccountEvent {
  const UpdateAccountBalance({
    final double? accountBalance,
    final String? accountId,
    final String? walletId,
  }) : super(
          accountBalance: accountBalance,
          accountId: accountId,
          walletId: walletId,
        );
}

class UpdateBankAccountName extends BankAccountEvent {
  const UpdateBankAccountName({
    final String? bankAccountName,
    final String? accountId,
    final String? walletId,
  }) : super(
          bankAccountName: bankAccountName,
          accountId: accountId,
          walletId: walletId,
        );
}

class UpdateSelectedAccount extends BankAccountEvent {
  const UpdateSelectedAccount({
    final bool? selectedAccount,
    final String? accountId,
    final String? walletId,
  }) : super(
          selectedAccount: selectedAccount,
          accountId: accountId,
          walletId: walletId,
        );
}

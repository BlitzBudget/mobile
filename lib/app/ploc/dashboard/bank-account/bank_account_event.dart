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
      {required final double? accountBalance,
      required final String? bankAccountName,
      required final bool? selectedAccount,
      required final String? accountId,
      required final String? walletId,
      required final bool? linked,
      required final AccountType? accountType,
      required final AccountSubType? accountSubType})
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
  const Delete({required final String? deleteItemId})
      : super(deleteItemId: deleteItemId);
}

class UpdateAccountBalance extends BankAccountEvent {
  const UpdateAccountBalance({
    required final double? accountBalance,
    required final String? accountId,
  }) : super(
          accountBalance: accountBalance,
          accountId: accountId,
        );
}

class UpdateBankAccountName extends BankAccountEvent {
  const UpdateBankAccountName({
    required final String? bankAccountName,
    required final String? accountId,
  }) : super(
          bankAccountName: bankAccountName,
          accountId: accountId,
        );
}

class UpdateSelectedAccount extends BankAccountEvent {
  const UpdateSelectedAccount({
    required final bool? selectedAccount,
    required final String? accountId,
    required final String? walletId,
  }) : super(
          selectedAccount: selectedAccount,
          accountId: accountId,
          walletId: walletId,
        );
}

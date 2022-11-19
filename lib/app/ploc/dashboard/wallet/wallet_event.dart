part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent(
      {this.userId,
      this.currency,
      this.walletId,
      this.walletName,
      this.totalDebtBalance,
      this.walletBalance,
      this.totalAssetBalance});

  final String? walletId;
  final String? userId;
  final String? walletName;
  final String? currency;
  final double? totalDebtBalance;
  final double? walletBalance;
  final double? totalAssetBalance;

  @override
  List<Object> get props => [];
}

class Delete extends WalletEvent {
  const Delete({required final String? walletId}) : super(walletId: walletId);
}

class Fetch extends WalletEvent {
  const Fetch() : super();
}

class UpdateWalletName extends WalletEvent {
  const UpdateWalletName(
      {required final String? walletId, required final String? walletName})
      : super(walletId: walletId, walletName: walletName);
}

class UpdateCurrency extends WalletEvent {
  const UpdateCurrency(
      {required final String? walletId, required final String? currency})
      : super(walletId: walletId, currency: currency);
}

class Add extends WalletEvent {
  const Add(
      {required final String? walletName, required final String? currency})
      : super(
          walletName: walletName,
          currency: currency,
        );
}

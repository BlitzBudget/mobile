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
  const Delete(final String? walletId) : super(walletId: walletId);
}

class Fetch extends WalletEvent {
  const Fetch(final String? walletId) : super(walletId: walletId);
}

class UpdateWalletName extends WalletEvent {
  const UpdateWalletName(final String? walletId, final String? walletName)
      : super(walletId: walletId, walletName: walletName);
}

class UpdateCurrency extends WalletEvent {
  const UpdateCurrency(final String? walletId, final String? currency)
      : super(walletId: walletId, currency: currency);
}

class Update extends WalletEvent {
  const Update(
    final String? walletId,
    final String? userId,
    final String? walletName,
    final String? currency,
    final double? totalDebtBalance,
    final double? walletBalance,
    final double? totalAssetBalance,
  ) : super(
            walletId: walletId,
            userId: userId,
            walletBalance: walletBalance,
            walletName: walletName,
            currency: currency,
            totalAssetBalance: totalAssetBalance,
            totalDebtBalance: totalDebtBalance);
}

class Add extends WalletEvent {
  const Add(
    final String? walletId,
    final String? userId,
    final String? walletName,
    final String? currency,
    final double? totalDebtBalance,
    final double? walletBalance,
    final double? totalAssetBalance,
  ) : super(
            walletId: walletId,
            userId: userId,
            walletBalance: walletBalance,
            walletName: walletName,
            currency: currency,
            totalAssetBalance: totalAssetBalance,
            totalDebtBalance: totalDebtBalance);
}

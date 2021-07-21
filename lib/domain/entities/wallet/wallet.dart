import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  const Wallet(
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
  List<Object?> get props => [
        walletId,
        userId,
        walletName,
        currency,
        totalDebtBalance,
        walletBalance,
        totalAssetBalance
      ];
}

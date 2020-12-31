import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

class WalletModel extends Wallet {
  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  WalletModel({
    String walletId,
    String userId,
    String walletName,
    String currency,
    double totalDebtBalance,
    double walletBalance,
    double totalAssetBalance,
  }) : super(
            userId: userId,
            currency: currency,
            walletId: walletId,
            walletName: walletName,
            totalDebtBalance: totalDebtBalance,
            walletBalance: walletBalance,
            totalAssetBalance: totalAssetBalance);

  /// Map JSON Wallet to List of object
  factory WalletModel.fromJSON(Map<String, dynamic> wallet) {
    return WalletModel(
        walletId: parseDynamicToString(wallet['walletId']),
        userId: parseDynamicToString(wallet['userId']),
        walletName: parseDynamicToString(wallet['name']),
        currency: parseDynamicToString(wallet['currency']),
        totalDebtBalance: parseDynamicToDouble(wallet['total_debt_balance']),
        walletBalance: parseDynamicToDouble(wallet['wallet_balance']),
        totalAssetBalance: parseDynamicToDouble(wallet['total_asset_balance']));
  }

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'userId': userId,
        'currency': currency,
        'name': walletName
      };
}

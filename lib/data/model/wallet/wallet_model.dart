import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

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
        walletId: parseDynamicAsString(wallet['walletId']),
        userId: parseDynamicAsString(wallet['userId']),
        walletName: parseDynamicAsString(wallet['name']),
        currency: parseDynamicAsString(wallet['currency']),
        totalDebtBalance: parseDynamicAsDouble(wallet['total_debt_balance']),
        walletBalance: parseDynamicAsDouble(wallet['wallet_balance']),
        totalAssetBalance: parseDynamicAsDouble(wallet['total_asset_balance']));
  }

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'userId': userId,
        'currency': currency,
        'name': walletName
      };
}

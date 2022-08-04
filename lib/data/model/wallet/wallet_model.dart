import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class WalletModel extends Wallet {
  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  const WalletModel({
    String? walletId,
    String? userId,
    String? walletName,
    String? currency,
  }) : super(
            userId: userId,
            currency: currency,
            walletId: walletId,
            walletName: walletName);

  /// Map JSON Wallet to List of object
  factory WalletModel.fromJSON(Map<String, dynamic> wallet) {
    return WalletModel(
        walletId: parseDynamicAsString(wallet['sk']),
        userId: parseDynamicAsString(wallet['pk']),
        walletName: parseDynamicAsString(wallet['wallet_name']),
        currency: parseDynamicAsString(wallet['wallet_currency']));
  }

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'sk': walletId,
        'pk': userId,
        'wallet_currency': currency,
        'wallet_name': walletName
      };
}

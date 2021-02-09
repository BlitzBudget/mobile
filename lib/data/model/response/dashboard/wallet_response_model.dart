import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/wallet_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class WalletResponseModel extends WalletResponse {
  WalletResponseModel(
      {List<Wallet> wallets,
     })
      : super(
            wallets: wallets);

  factory WalletResponseModel.fromJSON(
      Map<String, dynamic> walletResponseModel) {
    
    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    var responseCategories = walletResponseModel['Wallet'] as List;
    var convertedWallet = List<Wallet>.from(
        responseCategories?.map<dynamic>((dynamic model) =>
                WalletModel.fromJSON(model as Map<String, dynamic>)) ??
            <Wallet>[]);

    return WalletResponseModel(
        wallets: convertedWallet);
  }
}

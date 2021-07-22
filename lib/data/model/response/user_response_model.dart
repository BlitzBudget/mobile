import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class UserResponseModel extends UserResponse {
  const UserResponseModel(
      {String? refreshToken,
      String? authenticationToken,
      String? accessToken,
      User? user,
      Wallet? wallet})
      : super(
            refreshToken: refreshToken,
            authenticationToken: authenticationToken,
            accessToken: accessToken,
            user: user,
            wallet: wallet);

  factory UserResponseModel.fromJSON(Map<String, dynamic> userResponseModel) {
    final wallets = userResponseModel['Wallet'] ?? <dynamic>[];
    final wallet = wallets.isNotEmpty ? wallets[0] : <String, dynamic>{};
    return UserResponseModel(
        refreshToken: parseDynamicAsString(
            userResponseModel['AuthenticationResult']['RefreshToken']),
        authenticationToken: parseDynamicAsString(
            userResponseModel['AuthenticationResult']['IdToken']),
        accessToken: parseDynamicAsString(
            userResponseModel['AuthenticationResult']['AccessToken']),
        user: UserModel.fromJSON(
            userResponseModel['UserAttributes'] ?? <dynamic>[]),
        wallet: WalletModel.fromJSON(wallet));
  }
}

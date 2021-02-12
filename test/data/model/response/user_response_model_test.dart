import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final userModelAsString = fixture('responses/authentication/login_info.json');
  final userModelAsJSON = jsonDecode(userModelAsString);
  final userModel = UserResponseModel(
      accessToken: userModelAsJSON['AuthenticationResult']['AccessToken'],
      authenticationToken: userModelAsJSON['AuthenticationResult']['IdToken'],
      refreshToken: userModelAsJSON['AuthenticationResult']['RefreshToken'],
      user: UserModel.fromJSON(userModelAsJSON['UserAttributes']),
      wallet: WalletModel.fromJSON(userModelAsJSON['Wallet'][0]));
  test(
    'Should be a subclass of UserModel entity',
    () async {
      // assert
      expect(userModel, isA<UserResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final userModelConverted = UserResponseModel.fromJSON(userModelAsJSON);
      expect(userModelConverted, equals(userModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty Wallet data',
        () async {
      final userModelWithEmptyWalletAsString = fixture(
          'responses/partially-emtpy/authentication/empty_wallet_login_info.json');
      final userModelWithEmtpyWalletAsJSON =
          jsonDecode(userModelWithEmptyWalletAsString);
      final userModelWithEmtpyWalletConverted =
          UserResponseModel.fromJSON(userModelWithEmtpyWalletAsJSON);
      final userModelWithEmptyWallet = UserResponseModel(
          accessToken: userModelAsJSON['AuthenticationResult']['AccessToken'],
          authenticationToken: userModelAsJSON['AuthenticationResult']
              ['IdToken'],
          refreshToken: userModelAsJSON['AuthenticationResult']['RefreshToken'],
          user: UserModel.fromJSON(userModelAsJSON['UserAttributes']),
          wallet: WalletModel.fromJSON(const {}));
      expect(
          userModelWithEmtpyWalletConverted, equals(userModelWithEmptyWallet));
    });
  });
}

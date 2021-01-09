import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final userModelAsString = fixture('responses/authentication/login_info.json');
  final userModelAsJSON = jsonDecode(userModelAsString) as Map<String, dynamic>;
  final userModel = UserResponseModel(
      accessToken:
          userModelAsJSON['AuthenticationResult']['AccessToken'] as String,
      authenticationToken:
          userModelAsJSON['AuthenticationResult']['IdToken'] as String,
      refreshToken:
          userModelAsJSON['AuthenticationResult']['RefreshToken'] as String,
      user: UserModel.fromJSON(
          userModelAsJSON['UserAttributes'] as List<dynamic>),
      wallet: WalletModel.fromJSON(
          userModelAsJSON['Wallet'][0] as Map<String, dynamic>));
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
          jsonDecode(userModelWithEmptyWalletAsString) as Map<String, dynamic>;
      final userModelWithEmtpyWalletConverted =
          UserResponseModel.fromJSON(userModelWithEmtpyWalletAsJSON);
      final userModelWithEmptyWallet = UserResponseModel(
          accessToken:
              userModelAsJSON['AuthenticationResult']['AccessToken'] as String,
          authenticationToken:
              userModelAsJSON['AuthenticationResult']['IdToken'] as String,
          refreshToken:
              userModelAsJSON['AuthenticationResult']['RefreshToken'] as String,
          user: UserModel.fromJSON(
              userModelAsJSON['UserAttributes'] as List<dynamic>),
          wallet: WalletModel.fromJSON(<String, dynamic>{}));
      expect(
          userModelWithEmtpyWalletConverted, equals(userModelWithEmptyWallet));
    });
  });
}

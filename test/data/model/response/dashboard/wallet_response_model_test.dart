import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/wallet_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/entities/response/wallet_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final walletResponseModelAsString =
      fixture('responses/dashboard/wallet/fetch_wallet_info.json');
  final walletResponseModelAsJSON =
      jsonDecode(walletResponseModelAsString) as Map<String, dynamic>;

  /// Convert wallets from the response JSON to List<wallet>
  /// If Empty then return an empty object list
  final walletResponseModel = convertToResponseModel(walletResponseModelAsJSON);

  test(
    'Should be a subclass of walletModel entity',
    () async {
      // assert
      expect(walletResponseModel, isA<WalletResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final walletModelConverted =
          WalletResponseModel.fromJSON(walletResponseModelAsJSON);
      expect(walletModelConverted, equals(walletResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty bank account data',
        () async {
      final walletResponseModelWithEmptyBankAccountAsString = fixture(
          'responses/partially-emtpy/wallet/empty_bank_account_wallet_info.json');
      final walletResponseModelWithEmptyBankAccountAsJSON =
          jsonDecode(walletResponseModelWithEmptyBankAccountAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final walletResponseModelWithEmptyBankAccountConverted =
          convertToResponseModel(walletResponseModelWithEmptyBankAccountAsJSON);
      final walletResponseModelWithEmptyBankAccountFromJSON =
          WalletResponseModel.fromJSON(
              walletResponseModelWithEmptyBankAccountAsJSON);
      expect(walletResponseModelWithEmptyBankAccountFromJSON,
          equals(walletResponseModelWithEmptyBankAccountConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty date data',
        () async {
      final walletResponseModelWithEmptyDateAsString =
          fixture('responses/partially-emtpy/wallet/empty_date_wallet_info.json');
      final walletResponseModelWithEmptyDateAsJSON =
          jsonDecode(walletResponseModelWithEmptyDateAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final walletResponseModelWithEmptyDateConverted =
          convertToResponseModel(walletResponseModelWithEmptyDateAsJSON);
      final walletResponseModelWithEmptyDateFromJSON =
          WalletResponseModel.fromJSON(walletResponseModelWithEmptyDateAsJSON);
      expect(walletResponseModelWithEmptyDateFromJSON,
          equals(walletResponseModelWithEmptyDateConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty wallet data',
        () async {
      final walletResponseModelWithEmptywalletAsString =
          fixture('responses/partially-emtpy/wallet/empty_wallet_wallet_info.json');
      final walletResponseModelWithEmptywalletAsJSON =
          jsonDecode(walletResponseModelWithEmptywalletAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final walletResponseModelWithEmptywalletConverted =
          convertToResponseModel(walletResponseModelWithEmptywalletAsJSON);
      final walletResponseModelWithEmptywalletFromJSON =
          WalletResponseModel.fromJSON(walletResponseModelWithEmptywalletAsJSON);
      expect(walletResponseModelWithEmptywalletFromJSON,
          equals(walletResponseModelWithEmptywalletConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty wallet data',
        () async {
      final walletResponseModelWithEmptyWalletAsString =
          fixture('responses/partially-emtpy/wallet/empty_wallet_wallet_info.json');
      final walletResponseModelWithEmptyWalletAsJSON =
          jsonDecode(walletResponseModelWithEmptyWalletAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final walletResponseModelWithEmptyWalletConverted =
          convertToResponseModel(walletResponseModelWithEmptyWalletAsJSON);
      final walletResponseModelWithEmptyWalletFromJSON =
          WalletResponseModel.fromJSON(walletResponseModelWithEmptyWalletAsJSON);
      expect(walletResponseModelWithEmptyWalletFromJSON,
          equals(walletResponseModelWithEmptyWalletConverted));
    });
  });
}

WalletResponseModel convertToResponseModel(
    Map<String, dynamic> walletResponseModelAsJSON) {
 
    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    var responseCategories = walletResponseModelAsJSON['Wallet'] as List;
    var convertedWallet = List<Wallet>.from(
        responseCategories?.map<dynamic>((dynamic model) =>
                WalletModel.fromJSON(model as Map<String, dynamic>)) ??
            <Wallet>[]);

    return WalletResponseModel(
        wallets: convertedWallet);
}

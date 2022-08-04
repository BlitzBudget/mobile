import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final walletModelAsString = fixture('models/get/wallet/wallet_model.json');
  final walletModelAsJSON = jsonDecode(walletModelAsString);
  final walletModel = WalletModel(
      walletId: walletModelAsJSON['sk'],
      userId: walletModelAsJSON['pk'],
      currency: parseDynamicAsString(walletModelAsJSON['wallet_currency']),
      walletName: walletModelAsJSON['wallet_name']);
  test(
    'Should be a subclass of Wallet entity',
    () async {
      // assert
      expect(walletModel, isA<Wallet>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final walletModelConverted = WalletModel.fromJSON(walletModelAsJSON);
      expect(walletModelConverted, equals(walletModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addWalletModelAsString =
          fixture('models/add/wallet/wallet_model.json');
      final addWalletModelAsJSON = jsonDecode(addWalletModelAsString);
      expect(walletModel.toJSON(), equals(addWalletModelAsJSON));
    });
  });
}

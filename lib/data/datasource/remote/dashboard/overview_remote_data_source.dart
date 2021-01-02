import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/core/utils/utils.dart';

abstract class OverviewRemoteDataSource {
  Future<dynamic> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  final HTTPClient httpClient;

  OverviewRemoteDataSourceImpl({@required this.httpClient});

  /// Get Wallet
  @override
  Future<dynamic> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId) async {
    var contentBody = <String, dynamic>{
      'startsWithDate': startsWithDate,
      'endsWithDate': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['walletId'] = defaultWallet;
    } else {
      contentBody['userId'] = userId;
    }

    return httpClient
        .post(constants.overviewURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<dynamic>((dynamic res) {
      debugPrint('The response from the overview is $res');
      //TODO
      return res;
    });
  }
}

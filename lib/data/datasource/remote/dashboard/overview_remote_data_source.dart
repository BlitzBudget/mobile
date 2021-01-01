import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

abstract class OverviewRemoteDataSource {
  Future<void> get(Map<String, dynamic> contentBody);
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  final HTTPClient httpClient;

  OverviewRemoteDataSourceImpl({@required this.httpClient});

  /// Get Wallet
  @override
  Future<void> get(Map<String, dynamic> contentBody) async {
    developer
        .log('The Map for getting the overview is  ${contentBody.toString()}');

    return httpClient
        .post(constants.overviewURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the overview is $res');
      //TODO
    });
  }
}

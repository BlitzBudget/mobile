import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/response/dashboard/overview_response_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';

mixin OverviewRemoteDataSource {
  Future<OverviewResponse> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet,
      required String? userId});
}

class OverviewRemoteDataSourceImpl with OverviewRemoteDataSource {
  OverviewRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Get Wallet
  @override
  Future<OverviewResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet,
      required String? userId}) async {
    final contentBody = <String, dynamic>{
      'startsWithDate': startsWithDate,
      'endsWithDate': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['walletId'] = defaultWallet;
    } else {
      contentBody['userId'] = userId;
    }

    return httpClient!
        .post(constants.overviewURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<OverviewResponseModel>((dynamic res) {
      debugPrint('The response from the overview is $res');

      return OverviewResponseModel.fromJSON(res);
    });
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/overview_response_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';

abstract class OverviewRemoteDataSource {
  Future<OverviewResponse> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  final HTTPClient httpClient;

  OverviewRemoteDataSourceImpl({@required this.httpClient});

  /// Get Wallet
  @override
  Future<OverviewResponseModel> get(String startsWithDate, String endsWithDate,
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
        .then<OverviewResponseModel>((dynamic res) {
      debugPrint('The response from the overview is $res');

      return OverviewResponseModel.fromJSON(res as Map<String, dynamic>);
    });
  }
}

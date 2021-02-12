import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';

import '../../../constants/constants.dart' as constants;

mixin ChangePasswordRemoteDataSource {
  Future<void> changePassword(
      {String accessToken, String newPassword, String oldPassword});
}

class ChangePasswordRemoteDataSourceImpl
    with ChangePasswordRemoteDataSource {
  ChangePasswordRemoteDataSourceImpl({@required this.httpClient});

  final HTTPClient httpClient;

  /// Update User Attributes
  @override
  Future<void> changePassword(
      {String accessToken, String newPassword, String oldPassword}) async {
    return httpClient
        .post(constants.changePasswordURL,
            body: jsonEncode({
              'accessToken': accessToken,
              'newPassword': newPassword,
              'previousPassword': oldPassword
            }),
            headers: constants.headers)
        .then<void>((dynamic res) {
      developer
          .log('User Attributes  ${res['UserAttributes']}');
    });
  }
}

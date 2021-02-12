import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';

import '../../../constants/constants.dart' as constants;

mixin UserAttributesRemoteDataSource {
  Future<void> updateUserAttributes(UserModel userModel);
}

class UserAttributesRemoteDataSourceImpl
    with UserAttributesRemoteDataSource {
 

  UserAttributesRemoteDataSourceImpl({@required this.httpClient});

   final HTTPClient httpClient;

  /// Update User Attributes
  @override
  Future<void> updateUserAttributes(UserModel userModel) async {
    return httpClient
        .post(constants.userAttributesURL,
            body: jsonEncode(userModel.toJSON()), headers: constants.headers)
        .then<void>((dynamic res) {
      developer
          .log('User Attributes  ${res['UserAttributes']}');
    });
  }
}

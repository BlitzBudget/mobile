import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../data/authentication.dart' as authentication;
import '../screens/dashboard/full-screen-dialog/profile_dialog.dart' as profile;

class NetworkUtil {
  /// next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
  // Refresh Token
  static final refreshToken = authentication.baseURL + '/profile/refresh-token';

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      debugPrint(" The response code is " +
          statusCode.toString() +
          " with the response " +
          res);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        developer.log("Error while fetching data with status code " +
            statusCode.toString());

        /// If a 401 Unauthorized exception is thrown
        /// Consider refreshing the authorization token
        if (statusCode == 401) {
          return http
              .post(refreshToken,
                  body: body, headers: headers, encoding: encoding)
              .then((http.Response response) {
                  /// Store Access token and Authentication Token
                  authentication.RestDataSource _restDataSource = authentication.RestDataSource();
                  /// Create storage
                  final _storage = new FlutterSecureStorage();
                  _restDataSource.storeAccessToken(res, _storage);
                  _restDataSource.storeAuthToken(res, _storage);

                  return post(url,
                             body: body,
                             headers: headers,
                             encoding: encoding);
              });
          /// Logout And Redirect User
          // TODO profile.logoutAndRedirect(context);
        }
      }
      return _decoder.convert(res);
    });
  }
}

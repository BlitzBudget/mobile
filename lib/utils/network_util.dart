import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../constants.dart' as constants;
import '../data/authentication.dart' as authentication;
import '../screens/dashboard/full-screen-dialog/profile_dialog.dart' as profile;

/// API calls allowed
enum APICall { Post, Put, Patch }

class NetworkUtil {
  /// next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  /// Create storage
  final _storage = new FlutterSecureStorage();

  final JsonDecoder _decoder = new JsonDecoder();
  // Refresh Token
  static final refreshTokenURI =
      authentication.baseURL + '/profile/refresh-token';

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || res == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  /// Generic POST api call
  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    // Set Authorization header
    headers['Authorization'] =
        await _storage.read(key: constants.authToken);

    developer
        .log('The header is $headers');

    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      developer.log(
          " The response code is ${statusCode.toString()} with the response $res");

      if (statusCode < 200 || statusCode > 400 || res == null) {
        developer.log(
            "Error while fetching data with status code ${statusCode.toString()}");

        /// If a 401 Unauthorized exception is thrown
        /// Consider refreshing the authorization token
        if (statusCode == 401) {
          return refreshAuthToken(url, APICall.Post.toString(),
              body: body, headers: headers, encoding: encoding);
        }
      }
      return _decoder.convert(res);
    });
  }

  /// Generic PUT api call
  Future<dynamic> put(String url, {Map headers, body, encoding}) async {
      // Set Authorization header
    headers['Authorization'] =
        await _storage.read(key: constants.authToken);

  }

  /// Generic PATCH api call
  Future<dynamic> patch(String url, {Map headers, body, encoding}) async {
      // Set Authorization header
    headers['Authorization'] =
        await _storage.read(key: constants.authToken);

  }

  /// Refresh authorization token
  ///
  /// If successful call the API again
  /// If unsuccessful then logout
  Future<dynamic> refreshAuthToken(String url, String apiCallToMake,
      {Map headers, body, encoding}) async {
    debugPrint(
        " The authorization token has expired, Trying to refresh the token.");

    /// Store Access token and Authentication Token
    final refreshToken = await _storage.read(key: constants.refreshToken);

    return http
        .post(refreshTokenURI,
            body: jsonEncode({"refreshToken": refreshToken}),
            headers: headers,
            encoding: encoding)
        .then((http.Response response) async {
      final int statusCode = response.statusCode;
      final res = _decoder.convert(response.body);
      debugPrint(
          " The response code is ${statusCode.toString()} with the response $res");

      /// Check if the status code is error
      if (statusCode < 200 || statusCode > 400 || response == null) {
        debugPrint(
            "Error while fetching data with status code ${statusCode.toString()}");

        /// Logout And Redirect User
        profile.logoutAndRedirect();
        return;
      }

      debugPrint(" The authorization token has been refreshed successfully.");

      /// Store Access Token
      authentication.storeAccessToken(res, _storage);

      /// Store Auth Token
      authentication.storeAuthToken(res, _storage);

      // Set the new Authorization header
      headers['Authorization'] = res["AuthenticationResult"]["IdToken"];

      switch (apiCallToMake) {
        case "Patch":
          // Call the PATCH again
          return patch(url, body: body, headers: headers, encoding: encoding);
        case "Put":
          // Call the POST again
          return put(url, body: body, headers: headers, encoding: encoding);
        case "Post":
        default:
          // Call the POST again
          return post(url, body: body, headers: headers, encoding: encoding);
      }
    });
  }
}

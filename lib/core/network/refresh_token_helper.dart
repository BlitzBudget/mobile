import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';

import '../../data/constants/constants.dart';
import '../error/exceptions.dart';
import 'network_helper.dart';

class RefreshTokenHelper {
  final RefreshTokenRepository refreshTokenRepository;
  final AuthTokenRepository authTokenRepository;
  final AccessTokenRepository accessTokenRepository;
  final NetworkHelper networkHelper = NetworkHelper();

  RefreshTokenHelper({
    @required this.refreshTokenRepository,
    @required this.authTokenRepository,
    @required this.accessTokenRepository,
  });

  /// Refresh authorization token
  ///
  /// If successful call the API again
  /// If unsuccessful then logout
  Future<void> refreshAuthToken(
      Map<String, String> headers, Encoding encoding) async {
    debugPrint(
        ' The authorization token has expired, Trying to refresh the token.');

    /// Store Access token and Authentication Token
    final refreshToken = refreshTokenRepository.readRefreshToken();

    return http
        .post(refreshTokenURL,
            body: jsonEncode({'refreshToken': refreshToken}),
            headers: headers,
            encoding: encoding)
        .then((response) async {
      debugPrint(' The authorization token has been refreshed successfully.');

      dynamic res = _response(response);

      // Set the new Authorization header
      headers['Authorization'] =
          res['AuthenticationResult']['IdToken'] as String;
    });
  }

  /// Convert Relevant JSON types
  /// Throw Exceptions with status code
  dynamic _response(http.Response response) async {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 299) {
      if (response.body.isEmpty) {
        return <dynamic>[];
      } else {
        debugPrint(
            ' The response code is ${statusCode.toString()} with the response $response');
        dynamic res = jsonDecode(response.body);

        /// Store Auth Token
        await authTokenRepository
            .writeAuthToken(res['AuthenticationResult']['IdToken'] as String);

        /// Store Access Token
        await accessTokenRepository.writeAccessToken(
            res['AuthenticationResult']['AccessToken'] as String);

        return res;
      }
    } else if (statusCode >= 400 && statusCode <= 600) {
      throw UnableToRefreshTokenException();
    }
  }
}

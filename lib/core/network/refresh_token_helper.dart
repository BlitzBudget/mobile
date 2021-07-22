import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';

import '../../data/constants/constants.dart';
import 'network_helper.dart';

class RefreshTokenHelper {
  RefreshTokenHelper(
      {required this.refreshTokenRepository,
      required this.authTokenRepository,
      required this.accessTokenRepository,
      required this.networkHelper,
      required this.clearAllStorageRepository,
      required this.httpClient});

  late final RefreshTokenRepository refreshTokenRepository;
  late final AuthTokenRepository authTokenRepository;
  late final AccessTokenRepository accessTokenRepository;
  late final NetworkHelper networkHelper;
  late final ClearAllStorageRepository clearAllStorageRepository;
  late final http.Client httpClient;

  /// Refresh authorization token
  ///
  /// If successful call the API again
  /// If unsuccessful then logout
  Future<void> refreshAuthToken(
      Map<String, String?> headers, Encoding? encoding) async {
    debugPrint(
        ' The authorization token has expired, Trying to refresh the token.');

    /// Store Access token and Authentication Token
    final refreshToken = await refreshTokenRepository.readRefreshToken();

    /// If the refresh token is empty then throw exception
    if (refreshToken.isLeft()) {
      await clearStoreAndThrowException();
    }

    return httpClient
        .post(Uri.parse(refreshTokenURL),
            body:
                jsonEncode({'refreshToken': refreshToken.getOrElse(() => '')}),
            headers: headers as Map<String, String>?,
            encoding: encoding)
        .then((response) async {
      debugPrint(' The authorization token has been refreshed successfully.');

      final res = await _response(response);

      // Set the new Authorization header
      headers['Authorization'] =
          parseDynamicAsString(res['AuthenticationResult']['IdToken']);
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
        final res = jsonDecode(response.body);

        /// Map From JSON to user response model
        final user = UserResponseModel.fromJSON(res);

        /// Store Auth Token
        await authTokenRepository.writeAuthToken(user);

        /// Store Access Token
        await accessTokenRepository.writeAccessToken(user);

        return res;
      }
    } else if (statusCode >= 400 && statusCode <= 600) {
      /// Clear all Storage (keyValue and SecureKeyValue)
      await clearStoreAndThrowException();
    }
  }

  /// Clear all Storage (keyValue and SecureKeyValue)
  Future<void> clearStoreAndThrowException() async {
    await clearAllStorageRepository.clearAllStorage();
    throw UnableToRefreshTokenException();
  }
}

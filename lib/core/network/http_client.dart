import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

import 'network_helper.dart';
import 'refresh_token_helper.dart';

class HTTPClient {
  final AuthTokenRepository authTokenRepository;
  final AccessTokenRepository accessTokenRepository;
  final NetworkHelper networkHelper;
  final RefreshTokenHelper refreshTokenHelper;

  HTTPClient(
      {@required this.authTokenRepository,
      @required this.accessTokenRepository,
      @required this.refreshTokenHelper,
      @required this.networkHelper});

  Future<dynamic> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response =
          await networkHelper.post(url, body: body, headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      var response =
          await networkHelper.post(url, body: body, headers: headers);
      return _response(response);
    }
  }

  Future<dynamic> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response = await networkHelper.put(url, body: body, headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      var response = await networkHelper.put(url, body: body, headers: headers);
      return _response(response);
    }
  }

  Future<dynamic> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response =
          await networkHelper.patch(url, body: body, headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      var response =
          await networkHelper.patch(url, body: body, headers: headers);
      return _response(response);
    }
  }

  /// Convert Relevant JSON types
  /// Throw Exceptions with status code
  dynamic _response(Response response) async {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 299) {
      if (response.body.isEmpty) {
        return <dynamic>[];
      } else {
        return jsonDecode(response.body);
      }
    } else if (statusCode == 401) {
      throw TokenExpiredException();
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException();
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException();
    } else {
      throw UnknownException();
    }
  }

  /// Populate Authorization Header
  Future populateAuthHeader(Map<String, String> headers) async {
    var authToken = await authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (isEmpty(authToken)) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken;
  }
}

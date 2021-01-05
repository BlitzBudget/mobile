import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';

import 'network_helper.dart';
import 'refresh_token_helper.dart';

abstract class HTTPClient {
  Future<dynamic> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding});
  Future<dynamic> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding});
  Future<dynamic> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding});
}

class HTTPClientImpl implements HTTPClient {
  final AuthTokenRepository authTokenRepository;
  final AccessTokenRepository accessTokenRepository;
  final NetworkHelper networkHelper;
  final RefreshTokenHelper refreshTokenHelper;

  HTTPClientImpl(
      {@required this.authTokenRepository,
      @required this.accessTokenRepository,
      @required this.refreshTokenHelper,
      @required this.networkHelper});

  @override
  Future<dynamic> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response =
          await networkHelper.post(url, body: body, headers: headers);
      return _response(response);
    } on SocketException catch (e) {
      throw ConnectionException(e);
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      var response =
          await networkHelper.post(url, body: body, headers: headers);
      return _response(response);
    }
  }

  @override
  Future<dynamic> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response = await networkHelper.put(url, body: body, headers: headers);
      return _response(response);
    } on SocketException catch (e) {
      throw ConnectionException(e);
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      var response = await networkHelper.put(url, body: body, headers: headers);
      return _response(response);
    }
  }

  @override
  Future<dynamic> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    await populateAuthHeader(headers);
    try {
      var response =
          await networkHelper.patch(url, body: body, headers: headers);
      return _response(response);
    } on SocketException catch (e) {
      throw ConnectionException(e);
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
      throw TokenExpiredException(response);
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException(response);
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException(response);
    } else {
      throw UnknownException(response);
    }
  }

  /// Populate Authorization Header
  Future populateAuthHeader(Map<String, String> headers) async {
    var authToken = await authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (authToken.isLeft()) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken.getOrElse(null);
  }
}

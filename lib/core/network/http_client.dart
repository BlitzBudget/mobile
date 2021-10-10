import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';

import 'network_helper.dart';
import 'refresh_token_helper.dart';

// Possible http calls
enum HTTPAPICalls { post, put, patch }

abstract class HTTPClient {
  Future<dynamic> post(String url,
      {Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool? skipAuthCheck});
  Future<dynamic> put(String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding});
  Future<dynamic> patch(String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding});
}

class HTTPClientImpl implements HTTPClient {
  HTTPClientImpl(
      {required this.authTokenRepository,
      required this.accessTokenRepository,
      required this.refreshTokenHelper,
      required this.networkHelper});

  final AuthTokenRepository authTokenRepository;
  final AccessTokenRepository accessTokenRepository;
  final NetworkHelper networkHelper;
  final RefreshTokenHelper refreshTokenHelper;

  @override
  Future<dynamic> post(String url,
      {Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool? skipAuthCheck = false}) async {
    if (skipAuthCheck!) {
      return postWithoutAuthorizationCheck(url, body, headers);
    } else {
      return processAPICallAndRefreshTokenIfNeeded(
          url, body, headers!, encoding, HTTPAPICalls.post);
    }
  }

  @override
  Future<dynamic> put(String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    return processAPICallAndRefreshTokenIfNeeded(
        url, body, headers!, encoding, HTTPAPICalls.put);
  }

  @override
  Future<dynamic> patch(String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    return processAPICallAndRefreshTokenIfNeeded(
        url, body, headers!, encoding, HTTPAPICalls.patch);
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
      throw TokenExpiredException(jsonDecode(response.body));
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException(jsonDecode(response.body));
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException(jsonDecode(response.body));
    } else {
      throw UnknownException(jsonDecode(response.body));
    }
  }

  /// Populate Authorization Header
  Future<dynamic> populateAuthHeader(Map<String, String> headers) async {
    final authToken = await authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (authToken.isLeft()) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken.getOrElse(() => '');
  }

  /// Process API Calls and handle refresh token
  Future<dynamic> processAPICallAndRefreshTokenIfNeeded(
      String url,
      dynamic body,
      Map<String, String> headers,
      Encoding? encoding,
      HTTPAPICalls httpapiCalls) async {
    dynamic res;
    // Process Authorization Header
    await populateAuthHeader(headers);

    try {
      res = await makeAppropriateAPICall(url, body, headers, httpapiCalls);
    } on SocketException catch (e) {
      throw ConnectionException(e);
    } on TokenExpiredException {
      await refreshTokenHelper.refreshAuthToken(headers, encoding);

      /// Try to fetch the content after refreshing the token
      res = await makeAppropriateAPICall(url, body, headers, httpapiCalls);
    }
    return res;
  }

  // Make the relevant API Calls
  Future<dynamic> makeAppropriateAPICall(String url, dynamic body,
      Map<String, String>? headers, HTTPAPICalls httpapiCalls) async {
    late Response response;
    switch (httpapiCalls) {
      case HTTPAPICalls.post:
        response = await networkHelper.post(url, body: body, headers: headers);
        break;
      case HTTPAPICalls.put:
        response = await networkHelper.put(url, body: body, headers: headers);
        break;
      case HTTPAPICalls.patch:
        response = await networkHelper.patch(url, body: body, headers: headers);
        break;
      default:
    }
    return _response(response);
  }

  /// POST call without authorization check
  Future<dynamic> postWithoutAuthorizationCheck(
      String url, dynamic body, Map<String, String>? headers) async {
    try {
      return await makeAppropriateAPICall(
          url, body, headers, HTTPAPICalls.post);
    } on SocketException catch (e) {
      throw ConnectionException(e);
    }
  }
}

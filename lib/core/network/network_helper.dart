import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/network/network_info.dart';

class NetworkHelper {
  final NetworkInfo networkInfo;
  final http.Client httpClient;

  NetworkHelper({
    @required this.networkInfo,
    @required this.httpClient,
  });

  /// Generic POST api call
  Future<http.Response> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.post(url,
          body: body, headers: headers, encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }

  /// Generic PUT api call
  Future<http.Response> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.put(url,
          body: body, headers: headers, encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }

  /// Generic PATCH api call
  Future<http.Response> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.patch(url,
          body: body, headers: headers, encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }
}

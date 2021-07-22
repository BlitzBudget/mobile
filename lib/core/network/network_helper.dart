import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/network/network_info.dart';

class NetworkHelper {
  NetworkHelper({
    required this.networkInfo,
    required this.httpClient,
  });

  late final NetworkInfo networkInfo;
  late final http.Client httpClient;

  /// Generic POST api call
  Future<http.Response> post(String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.post(Uri.parse(url),
          body: body, headers: headers, encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }

  /// Generic PUT api call
  Future<http.Response> put(String url,
      {Map<String, String?>? headers, dynamic body, Encoding? encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.put(Uri.parse(url),
          body: body,
          headers: headers as Map<String, String>?,
          encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }

  /// Generic PATCH api call
  Future<http.Response> patch(String url,
      {Map<String, String?>? headers, dynamic body, Encoding? encoding}) async {
    if (await networkInfo.isConnected) {
      return httpClient.patch(Uri.parse(url),
          body: body,
          headers: headers as Map<String, String>?,
          encoding: encoding);
    } else {
      throw NoNetworkConnectionException();
    }
  }
}

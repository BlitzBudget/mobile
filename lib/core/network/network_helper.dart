import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  /// Generic POST api call
  Future<http.Response> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    return http.post(url, body: body, headers: headers, encoding: encoding);
  }

  /// Generic PUT api call
  Future<http.Response> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    return http.put(url, body: body, headers: headers, encoding: encoding);
  }

  /// Generic PATCH api call
  Future<http.Response> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    return http.patch(url, body: body, headers: headers, encoding: encoding);
  }
}

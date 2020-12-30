import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../app/constants/constants.dart' as constants;

class NetworkHelper {
  /// Generic POST api call
  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    return http.post(url, body: body, headers: headers, encoding: encoding);
  }

  /// Generic PUT api call
  Future<dynamic> put(String url, {Map headers, body, encoding}) async {
    return http.put(url, body: body, headers: headers, encoding: encoding);
  }

  /// Generic PATCH api call
  Future<dynamic> patch(String url, {Map headers, body, encoding}) async {
    return http.patch(url, body: body, headers: headers, encoding: encoding);
  }
}

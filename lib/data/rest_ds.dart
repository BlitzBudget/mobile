import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/utils/network_util.dart';
import 'package:mobile_blitzbudget/models/user.dart';

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://api.blitzbudget.com";
  static final LOGIN_URL = BASE_URL + "/profile/sign-in";
  static final APPLICAION_JSON = "application/json";
  static final headers = {
      'Content-type': 'application/json;charset=UTF-8',
      'Accept': 'application/json'
  };
  static final CHECK_PASSWORD = false;

  Future<User> attemptLogin(String username, String password) {
    return _netUtil.post(LOGIN_URL,
    body: jsonEncode({
      "username": username,
      "password": password,
      "checkPassword": CHECK_PASSWORD
    }),
    headers: headers).then((dynamic res) {
      developer.log("User Attributes" + res['UserAttributes'].toString());
      if(res["errorType"] != null) throw new Exception(res["errorMessage"]);
      return new User.map(res["UserAttributes"]);
    });
  }
}

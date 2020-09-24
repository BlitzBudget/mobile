import 'dart:async';
import 'dart:convert';

import 'package:mobile_blitzbudget/utils/network_util.dart';
import 'package:mobile_blitzbudget/models/user.dart';

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://api.blitzbudget.com";
  static final LOGIN_URL = BASE_URL + "/profile/sign-in";

  Future<User> attemptLogin(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: jsonEncode({
      "username": username,
      "password": password
    }),
    headers: {
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(res["user"]);
    });
  }
}

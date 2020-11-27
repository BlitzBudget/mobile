import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Utils/network_util.dart';
import '../models/user.dart';
import '../Utils/utils.dart';
import '../constants.dart';

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
  // Create storage
  final storage = new FlutterSecureStorage();
  static final RegExp passwordExp = new RegExp(r'^[a-zA-Z0-9!@#$&()\-`.+,/\"]*$');

  Future<User> attemptLogin(BuildContext context, String email, String password) async {
    if(!EmailValidator.validate(email)) {
        displayDialog(context, "Email", "The email is not valid");
        return null;
    } else if(password != null || !passwordExp.hasMatch(password)) {
        displayDialog(context, "Password", "The password is not valid");
        return null;
    }

    return _netUtil.post(LOGIN_URL,
    body: jsonEncode({
      "username": email,
      "password": password,
      "checkPassword": CHECK_PASSWORD
    }),
    headers: headers).then((dynamic res) {
      developer.log("User Attributes" + res['UserAttributes'].toString());
      if(res["errorType"] != null)  {
          displayDialog(context, "An Error Occurred", res["errorMessage"]);
          return null;
      }
      // User
      User user = new User.map(res["UserAttributes"]);
      // Store User Attributes
      _storeUserAttributes(user, storage);
      // Store Refresh Token
      _storeRefreshToken(res, storage);
      // Store Access Token
      _storeAccessToken(res, storage);
      // Store Auth Token
      _storeAuthToken(res, storage);
      return user;
    });
  }

  void _storeUserAttributes(User user, FlutterSecureStorage storage) async {
      // Write User Attributes
      await storage.write(key: userAttributes, value: user.toString());
  }

  void _storeRefreshToken(dynamic res, FlutterSecureStorage storage) async {
      // Write Refresh Token
      await storage.write(key: refreshToken, value: res["AuthenticationResult"]["RefreshToken"]);
  }

  void _storeAccessToken(dynamic res, FlutterSecureStorage storage) async {
      // Write Access Token
      await storage.write(key: accessToken, value: res["AuthenticationResult"]["AccessToken"]);
  }

  void _storeAuthToken(dynamic res, FlutterSecureStorage storage) async {
      // Write Id Token
      await storage.write(key: authToken, value: res["AuthenticationResult"]["IdToken"]);
  }

}

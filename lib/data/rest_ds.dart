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
  static final SIGNUP_URL = BASE_URL + "/profile/sign-up";
  static final APPLICAION_JSON = "application/json";
  static final headers = {
    'Content-type': 'application/json;charset=UTF-8',
    'Accept': 'application/json'
  };
  static final CHECK_PASSWORD = false;
  // Create storage
  final storage = new FlutterSecureStorage();
  static final RegExp passwordExp = new RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
  static final RegExp emailExp = new RegExp(r"^[!#$%&'*+-\/=?^_`{|}~]");

  Future<User> attemptLogin(
      BuildContext context, String email, String password) async {
    if (isEmpty(email)) {
      displayDialog(context, "Empty Email", "The email cannot be empty");
      return null;
    } else if (!EmailValidator.validate(email)) {
      displayDialog(context, "Invalid Email", "The email is not valid");
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, "Empty Password", "The password cannot be empty");
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, "Invalid Password", "The password is not valid");
      return null;
    }

    return _netUtil
        .post(LOGIN_URL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "checkPassword": CHECK_PASSWORD
            }),
            headers: headers)
        .then((dynamic res) {
      developer.log("User Attributes" + res['UserAttributes'].toString());
      if (res["errorType"] != null) {
        // Conditionally process error messages
        if (includesStr(res["errorMessage"], 'UserNotFoundException')) {
          var fullname = email.split('@')[0];
          var names = fetchNames(fullname);
          // Start signup process
          /*return _netUtil.post(SIGNUP_URL,
                    body: jsonEncode({
                      "username": email.toLowerCase(),
                      "password": password,
                      "firstname": fullname,
                      "lastname": fullname,
                      "checkPassword": CHECK_PASSWORD
                    }),
                    headers: headers).then((dynamic res) {
                    }*/
        } else {
          displayDialog(context, "Not Authorized",
              "The email or password entered is incorrect");
        }
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

  void fetchNames(String fullname) {
    Iterable<RegExpMatch> matchFound = emailExp.allMatches(fullname);
    debugPrint('First match: ${matchFound.length}');
  }

  void _storeUserAttributes(User user, FlutterSecureStorage storage) async {
    // Write User Attributes
    await storage.write(key: userAttributes, value: user.toString());
  }

  void _storeRefreshToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Refresh Token
    await storage.write(
        key: refreshToken, value: res["AuthenticationResult"]["RefreshToken"]);
  }

  void _storeAccessToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Access Token
    await storage.write(
        key: accessToken, value: res["AuthenticationResult"]["AccessToken"]);
  }

  void _storeAuthToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Id Token
    await storage.write(
        key: authToken, value: res["AuthenticationResult"]["IdToken"]);
  }
}

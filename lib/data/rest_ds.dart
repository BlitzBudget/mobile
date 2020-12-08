import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../screens/authentication/verify/verify_screen.dart';
import '../utils/network_util.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import '../constants.dart';
import '../routes.dart';

/// Name Object for firstname and lastName
class Name {
  String firstName;
  String surName;

  Name(this.firstName, this.surName);
}

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://api.blitzbudget.com";
  static final LOGIN_URL = BASE_URL + "/profile/sign-in";
  static final SIGNUP_URL = BASE_URL + "/profile/sign-up";
  static final APPLICAION_JSON = "application/json";
  var headers = {
    'Content-type': 'application/json;charset=UTF-8',
    'Accept': 'application/json'
  };
  static final CHECK_PASSWORD = false;
  // Create storage
  final storage = new FlutterSecureStorage();
  static final RegExp passwordExp = new RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
  static final RegExp emailExp = new RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");
  static final String userNotFoundException = 'UserNotFoundException';
  static final String userNotConfirmedException = 'UserNotConfirmedException';

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
  Future<User> attemptLogin(
      BuildContext context, String email, String password) async {
    if (isEmpty(email)) {
      displayDialog(context, "Empty Email", "The email cannot be empty");
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, "Invalid Email", "The email is not valid");
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, "Empty Password", "The password cannot be empty");
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, "Invalid Password", "The password is not valid");
      return null;
    }

    // Convert email to lowercase and trim
    email = email.toLowerCase().trim();
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
        if (includesStr(res["errorMessage"], userNotFoundException)) {
          // Signup user and parse the response
          // TODO call signup
        } else if (includesStr(
            res["errorMessage"], userNotConfirmedException)) {
          // Navigate to the second screen using a named route.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyScreen(email: email, password: password),
            ),
          );
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

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
  Future<bool> signupUser(
      BuildContext context, String email, String password) async {
    // Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    var fullname = email.split('@')[0];
    var names = fetchNames(fullname);

    // Add accept language headers
    headers['Accept-Language'] = await Devicelocale.currentLocale;

    // Start signup process
    return _netUtil
        .post(SIGNUP_URL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "firstname": names.firstName,
              "lastname": names.surName,
              "checkPassword": CHECK_PASSWORD
            }),
            headers: headers)
        .then((dynamic res) {
      // Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error signing up", res["errorMessage"]);
        return false;
      }
      return true;
    });
  }

  /// Parse the user name with Email
  Name fetchNames(String fullname) {
    Match match = emailExp.firstMatch(fullname);
    Name name;

    if (match == null) {
      developer.log('No match found for ${fullname}');
      // Sur name cannot be empty
      name = Name(fullname, ' ');
    } else {
      // TODO SPLIT the name and then assign it to first and surname
      name = Name(fullname, ' ');
      developer.log(
          'Fullname ${fullname}, First match: ${match.start}, end Match: ${match.input}');
    }

    return name;
  }

  /// Verification Code
  ///
  /// Verify Email with confirmation code
  Future<bool> verifyEmail(BuildContext context, String email, String password,
      String verificationCode) {
    // Start signup process
    return _netUtil
        .post(SIGNUP_URL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "confirmationCode": verificationCode,
              "confirmationCode": false
            }),
            headers: headers)
        .then((dynamic res) {
      // Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error Verifying", res["errorMessage"]);
        return false;
      }
      return true;
    });
  }

  /// Resend Verification Code
  Future<bool>  resendVerificationCode(String email) {
      // TODO
  }
}

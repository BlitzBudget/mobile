import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'resend_verification.dart';
import '../../../../constants.dart';
import '../../../../utils/utils.dart';
import '../../../../data/authentication.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../../components/linear_loading_indicator.dart';

// Public exposed class
class Body extends StatefulWidget {
  final String email, password;
  final bool useVerifyURL;

  // In the constructor, require a Todo.
  // The verify URL is true by default
  Body(
      {Key key,
      @required this.email,
      @required this.password,
      this.useVerifyURL = true})
      : super(key: key);

  @override
  _BodyState createState() =>
      _BodyState(this.email, this.password, this.useVerifyURL);
}

class _BodyState extends State<Body> {
  // States
  bool _btnEnabled = true;

  RestDataSource _restDataSource = RestDataSource();
  String verificationCode;
  final String verifyEmail = "Verify Email";
  final String verificationCodeText = "Your verification code";
  String verifyButton = "VERIFY";
  final String email, password;
  final bool useVerifyURL;

  // In the constructor, require a body state.
  _BodyState(this.email, this.password, this.useVerifyURL);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //  Linear Progress indicator for loading
            // Show text only when the button is enabled
            Visibility(
                visible: _btnEnabled,
                child: Text(
                  verifyEmail,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                replacement: LinearLoadingIndicator()),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
                hintText: verificationCodeText,
                onChanged: (value) async {
                  verificationCode = value;
                  // If the length of the string is == 6 then submit the code for verification
                  if (isNotEmpty(verificationCode) &&
                      verificationCode.length >= 6) {
                    await _verifyEmailAndSetState(context, email, password, verificationCode, useVerifyURL);
                  }
                },
                autofocus: true),
            RoundedButton(
              text: verifyButton,
              press: () async {
                await _verifyEmailAndSetState(context, email, password, verificationCode, useVerifyURL);
              },
              enabled: _btnEnabled,
            ),
            SizedBox(height: size.height * 0.03),
            ResendVerification(email: email),
          ],
        ),
      ),
    );
  }

  // Verify Email And set state of the widget
  void _verifyEmailAndSetState(BuildContext context,final String email,final String password,final String verificationCode,final bool useVerifyURL) async {
      _loadingState();
                await _restDataSource.verifyEmail(
                    context, email, password, verificationCode, useVerifyURL);
                _defaultState();
  }

  // Set the state of the verification widget to loading
  void _loadingState() {
      setState(() {
                  verifyButton = "Loading";
                  _btnEnabled = false;
                });
  }

  // Set the state of the verification widget back to default
  void _defaultState() {
      setState(() {
                  verifyButton = "VERIFY";
                  _btnEnabled = true;
                });
  }
}

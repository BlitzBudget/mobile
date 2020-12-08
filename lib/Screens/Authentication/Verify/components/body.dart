import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'resend_verification.dart';
import '../../../../constants.dart';
import '../../../../utils/utils.dart';
import '../../../../data/authentication.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = RestDataSource();
  String verificationCode;
  final String verifyEmail = "Verify Email";
  final String verificationCodeText = "Your verification code";
  final String verifyButton = "VERIFY";
  final String email;
  final String password;

  // In the constructor, require a Todo.
  Body({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              verifyEmail,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                    await _restDataSource.verifyEmail(
                        context, email, password, verificationCode);
                  }
                },
                autofocus: true),
            RoundedButton(
              text: verifyButton,
              press: () async {
                await _restDataSource.verifyEmail(context, email, password, verificationCode);
              },
            ),
            SizedBox(height: size.height * 0.03),
            ResendVerification(email: email),
          ],
        ),
      ),
    );
  }

  /// Verify the email with the given verification code
  void _verifyEmail(BuildContext context, final String email,
      final String password, final String verificationCode) async {
    bool success = await _restDataSource.verifyEmail(
        context, email, password, verificationCode);
    if (success) {
      // Navigate to the second screen using a named route.
      Navigator.pushNamed(context, dashboardRoute);
    }
  }
}

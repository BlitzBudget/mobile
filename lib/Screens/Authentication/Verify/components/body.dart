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

  // In the constructor, require a Todo.
  Body({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(this.email, this.password);
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

  // In the constructor, require a body state.
  _BodyState(this.email, this.password);

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
                    await _restDataSource.verifyEmail(
                        context, email, password, verificationCode);
                  }
                },
                autofocus: true),
            RoundedButton(
              text: verifyButton,
              press: () async {
                setState(() {
                  verifyButton = "Loading";
                  _btnEnabled = false;
                });
                await _restDataSource.verifyEmail(
                    context, email, password, verificationCode);
                setState(() {
                  verifyButton = "VERIFY";
                  _btnEnabled = true;
                });
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
}

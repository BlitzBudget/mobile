import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../components/password_constraint_container.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../../data/authentication.dart';
import '../../../components/linear_loading_indicator.dart';
import '../../../../utils/utils.dart';
import '../../../../constants.dart';

// Public exposed class
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
 /// States
  bool _btnEnabled = true;

  RestDataSource _restDataSource = RestDataSource();
  TextEditingController controller;
  String username, password;
  final login = "LOGIN";
  final yourEmail = "Your Email";
  String continueButton = "CONTINUE";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           ///  Linear Progress indicator for loading
           /// Show text only when the button is enabled
            Visibility(
                visible: _btnEnabled,
                child: Text(
                  login,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                replacement: LinearLoadingIndicator()),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
                hintText: yourEmail,
                onChanged: (value) {
                  username = value;
                },
                autofocus: true),
            RoundedPassword(
              onChanged: (value) {
                password = value;
              },
            ),
            PasswordConstraint(),
            RoundedButton(
              text: continueButton,
             /// Disable press if button is disabled
              press: () async {
                setState(() {
                  continueButton = "Loading";
                  _btnEnabled = false;
                });
               /// Attempt login
                await _restDataSource.attemptLogin(context, username, password);
                setState(() {
                  continueButton = "CONTINUE";
                  _btnEnabled = true;
                });
              },
              color: primaryColor,
              enabled: _btnEnabled,
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
               /// Navigate to the second screen using a named route.
                Navigator.pushNamed(context, forgotPasswordRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}

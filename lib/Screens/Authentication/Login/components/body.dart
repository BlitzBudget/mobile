import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../../data/rest_ds.dart';
import '../../../../utils/utils.dart';
import '../../../../constants.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = RestDataSource();
  TextEditingController controller;
  String username, password;
  static final login = "LOGIN";
  static final yourEmail = "Your Email";
  static final continueButton = "CONTINUE";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              login,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            RoundedButton(
              text: continueButton,
              press: () async {
                var user = await _restDataSource.attemptLogin(
                    context, username, password);
                if (isNotEmpty(user)) {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, dashboardRoute);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, signupRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}

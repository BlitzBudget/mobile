import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';
import '../../Login/login_screen.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/password_constraint_container.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../verify/verify_screen.dart';
import '../../../../data/rest_ds.dart';
import '../../../../constants.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = RestDataSource();
  String email, password;
  final signupText = "SIGNUP";
  final yourEmail = "Your Email";
  final signupButton = "SIGNUP";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              signupText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
                hintText: yourEmail,
                onChanged: (value) {
                  email = value;
                },
                autofocus: true),
            RoundedPassword(
              onChanged: (value) {
                password = value;
              },
            ),
            PasswordConstraint(),
            RoundedButton(
              text: signupButton,
              press: () async {
                bool success =
                    await _restDataSource.signupUser(context, email, password);
                if (success) {
                  // Navigate to the second screen using a named route.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerifyScreen(email: email, password: password),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, loginRoute);
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

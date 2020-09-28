import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/Screens/Login/login_screen.dart';
import 'package:mobile_blitzbudget/Screens/Signup/components/background.dart';
import 'package:mobile_blitzbudget/Screens/Signup/components/or_divider.dart';
import 'package:mobile_blitzbudget/Screens/Signup/components/social_icon.dart';
import 'package:mobile_blitzbudget/components/already_have_an_account_acheck.dart';
import 'package:mobile_blitzbudget/components/rounded_button.dart';
import 'package:mobile_blitzbudget/components/rounded_input_field.dart';
import 'package:mobile_blitzbudget/components/rounded_password_field.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/dashboard_screen.dart';
import 'package:mobile_blitzbudget/constants.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, dashboardRoute);
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

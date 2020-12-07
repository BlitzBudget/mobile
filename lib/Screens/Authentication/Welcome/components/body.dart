import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import '../../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../Login/login_screen.dart';
import '../../components/rounded_button.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO BlitzBudget",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, loginRoute);
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: primaryLightColor,
              textColor: Colors.black,
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

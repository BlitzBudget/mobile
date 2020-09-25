import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/Screens/Login/components/background.dart';
import 'package:mobile_blitzbudget/Screens/Signup/signup_screen.dart';
import 'package:mobile_blitzbudget/components/already_have_an_account_acheck.dart';
import 'package:mobile_blitzbudget/components/rounded_button.dart';
import 'package:mobile_blitzbudget/components/rounded_input_field.dart';
import 'package:mobile_blitzbudget/components/rounded_password_field.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/dashboard_screen.dart';
import 'package:mobile_blitzbudget/data/rest_ds.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = new RestDataSource();
  TextEditingController controller;
  String username, password;

  void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text)
        ),
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                  username = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                  password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                var user = await _restDataSource.attemptLogin(username, password);
                if(user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DashboardScreen();
                        },
                      ),
                    );
                } else {
                    displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

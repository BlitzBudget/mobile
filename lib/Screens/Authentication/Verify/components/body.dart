import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import '../../../../routes.dart';
import '../../../../data/rest_ds.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = RestDataSource();
  String verificationCode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Verify Email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
                hintText: "Your verification code",
                onChanged: (value) {
                  verificationCode = value;
                },
                autofocus: true
            ),
            RoundedButton(
              text: "VERIFY",
              press: () async {
                bool success = await _restDataSource.verifyEmail(
                    context, verificationCode);
                if (success) {
                  // Navigate to the second screen using a named route.
                  // Navigator.pushNamed(context, dashboardRoute);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}

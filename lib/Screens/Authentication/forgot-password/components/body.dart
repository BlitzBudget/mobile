import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import '../../../../constants.dart';
import '../../../../utils/utils.dart';
import '../../../../data/authentication.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../../components/linear_loading_indicator.dart';

// Public exposed class
class Body extends StatefulWidget {
  final String email;

  // In the constructor, require a Todo.
  Body({Key key, @required this.email})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(this.email);
}

class _BodyState extends State<Body> {
  // States
  bool _btnEnabled = true;

  RestDataSource _restDataSource = RestDataSource();
  final String forgotPasswordText = "Forgot Password";
  String forgotPasswordButton = "FORGOT PASSWORD";
  final yourEmail = "Your Email";
  final String email;

  // In the constructor, require a body state.
  _BodyState(this.email);

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
                  forgotPasswordText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                replacement: LinearLoadingIndicator()),
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
                autofocus: true
            ),
            RoundedButton(
              text: forgotPasswordButton,
              press: () async {
                setState(() {
                  forgotPasswordButton = "Loading";
                  _btnEnabled = false;
                });
                await _restDataSource.verifyEmail(
                    context, email, password, verificationCode);
                setState(() {
                  forgotPasswordButton = "FORGOT PASSWORD";
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

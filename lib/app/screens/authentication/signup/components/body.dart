import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';
import '../../Login/login_screen.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/password_constraint_container.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../verify/verify_screen.dart';
import '../../../../../data/datasource/remote/authentication_remote_data_source.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/linear_loading_indicator.dart';

// Public exposed class
class Body extends StatefulWidget {
  final String email, password;

  /// In the constructor, require a Todo.
  Body({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(this.email, this.password);
}

class _BodyState extends State<Body> {
  /// States
  bool _btnEnabled = true;

  final AuthenticationRemoteDataSource _AuthenticationRemoteDataSource;
  final String email, password;
  String confirmPassword;
  final signupText = "SIGNUP";
  final yourEmail = "Your Email";
  String signupButton = "SIGNUP";

  /// Constructor for the private class
  _BodyState(this.email, this.password);

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
                  signupText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                replacement: LinearLoadingIndicator()),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RoundedPassword(
                onChanged: (value) {
                  confirmPassword = value;
                },
                autofocus: true),
            PasswordConstraint(),
            RoundedButton(
              text: signupButton,
              press: () async {
                setState(() {
                  signupButton = "Loading";
                  _btnEnabled = false;
                });
                await _AuthenticationRemoteDataSource.signupUser(
                    context, email, password, confirmPassword);
                setState(() {
                  signupButton = "SIGNUP";
                  _btnEnabled = true;
                });
              },
              enabled: _btnEnabled,
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                /// Navigate to the second screen using a named route.
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

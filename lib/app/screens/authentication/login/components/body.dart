import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/password_constraint_container.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../forgot-password/forgot_password_screen.dart';
import 'background.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// States
  bool _btnEnabled = true;

  TextEditingController controller;
  String username, password;
  final login = 'LOGIN';
  final yourEmail = 'Your Email';
  String continueButton = 'CONTINUE';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ///  Linear Progress indicator for loading
            /// Show text only when the button is enabled
            Visibility(
              visible: _btnEnabled,
              replacement: const LinearLoadingIndicator(),
              child: Text(
                login,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              'assets/icons/login.svg',
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
            const PasswordConstraint(),
            RoundedButton(
              text: continueButton,

              /// Disable press if button is disabled
              press: () async {
                setState(() {
                  continueButton = 'Loading';
                  _btnEnabled = false;
                });

                /*/// Attempt login
                await _AuthenticationRemoteDataSource.attemptLogin(
                    context, username, password);*/
                setState(() {
                  continueButton = 'CONTINUE';
                  _btnEnabled = true;
                });
              },
              enabled: _btnEnabled,
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                /// Navigate to the second screen using a named route.
                Navigator.push(
                  context,
                  MaterialPageRoute<ForgotPasswordScreen>(
                    builder: (context) => ForgotPasswordScreen(
                        email: username, password: password),
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

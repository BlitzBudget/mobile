import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import 'background.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor, require a Todo.
  const Body({Key key, this.email, this.password}) : super(key: key);

  final String email, password;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  _BodyState();

  /// States
  bool _btnEnabled = true;
  final String forgotPasswordText = 'Forgot Password';
  String forgotPasswordButton = 'FORGOT PASSWORD';
  final yourEmail = 'Your Email';
  final String hintPassword = 'New Password';

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
                forgotPasswordText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              'assets/icons/signup.svg',
              height: size.height * 0.35,
            ),
            RoundedInputField(
                initialValue: widget.email,
                hintText: yourEmail,
                onChanged: (value) {
                  //widget.email = value;
                },
                autofocus: true),
            RoundedPassword(
                initialValue: widget.password,
                onChanged: (value) {
                  //widget.password = value;
                },
                hintText: hintPassword),
            RoundedButton(
              text: forgotPasswordButton,
              press: () async {
                setState(() {
                  forgotPasswordButton = 'Loading';
                  _btnEnabled = false;
                });
                // TODO
                /*await _AuthenticationRemoteDataSource.forgotPassword(
                    context, widget.email, widget.password);*/
                setState(() {
                  forgotPasswordButton = 'FORGOT PASSWORD';
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
          ],
        ),
      ),
    );
  }
}

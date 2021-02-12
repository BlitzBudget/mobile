import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import 'background.dart';
import 'resend_verification.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor, require a Todo.
  /// The verify URL is true by default
  const Body(
      {Key key,
      @required this.email,
      @required this.password,
      this.useVerifyURL,
      this.showResendVerificationCode})
      : super(key: key);

  final String email, password;
  final bool useVerifyURL;
  final bool showResendVerificationCode;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// In the constructor, require a body state.
  _BodyState();

  /// States
  final bool _btnEnabled = true;

  String verificationCode;
  final String verifyEmail = 'Verify Email';
  final String verificationCodeText = 'Your verification code';
  String verifyButton = 'VERIFY';

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
                  verifyEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              'assets/icons/signup.svg',
              height: size.height * 0.35,
            ),
            RoundedInputField(
                hintText: verificationCodeText,
                onChanged: (value) async {
                  verificationCode = value;
                  // TODO
                  /* /// If the length of the string is == 6 then submit the code for verification
                  if (isNotEmpty(verificationCode) &&
                      verificationCode.length >= 6) {
                    await _verifyEmailAndSetState(context, email, password,
                        verificationCode, useVerifyURL);
                  }*/
                },
                autofocus: true),
            RoundedButton(
              text: verifyButton,
              press: () async {
                //TODO
                /* _verifyEmailAndSetState(
                    context, email, password, verificationCode, useVerifyURL);*/
              },
              enabled: _btnEnabled,
            ),
            SizedBox(height: size.height * 0.03),

            /// Show text only when the showResendVerificationCode is enabled
            Visibility(
              visible: widget.showResendVerificationCode,
              child: ResendVerification(email: widget.email),
            ),
          ],
        ),
      ),
    );
  }

  /* /// Verify Email And set state of the widget
  void _verifyEmailAndSetState(
      BuildContext context,
      final String email,
      final String password,
      final String verificationCode,
      final bool useVerifyURL) async {
    _loadingState();
    await _AuthenticationRemoteDataSource.verifyEmail(
        context, email, password, verificationCode, useVerifyURL);
    _defaultState();
  }

  /// Set the state of the verification widget to loading
  void _loadingState() {
    setState(() {
      verifyButton = "Loading";
      _btnEnabled = false;
    });
  }

  /// Set the state of the verification widget back to default
  void _defaultState() {
    setState(() {
      verifyButton = "VERIFY";
      _btnEnabled = true;
    });
  }*/
}

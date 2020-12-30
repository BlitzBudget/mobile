import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../data/datasource/remote/authentication_remote_data_source.dart';
import '../../../../constants/constants.dart';

// Public exposed class
class ResendVerification extends StatefulWidget {
  final String email;

  /// In the constructor, require an email.
  ResendVerification({Key key, @required this.email}) : super(key: key);

  @override
  _ResendVerificationState createState() =>
      _ResendVerificationState(this.email);
}

class _ResendVerificationState extends State<ResendVerification> {
  /// States
  bool _btnEnabled = true;
  Timer _timer;
  final String email;
  final timeout = const Duration(seconds: 60);
  final AuthenticationRemoteDataSource _AuthenticationRemoteDataSource;

  _ResendVerificationState(this.email);

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /// Show text only when the button is enabled
        Visibility(
            visible: _btnEnabled,
            child: Text(
              'Resend ',
              style: TextStyle(color: primaryColor),
            )),
        GestureDetector(
          onTap: () async {
            _toggleTextState(false);
            await _AuthenticationRemoteDataSource.resendVerificationCode(
                context, email);
            // Show the text again after a period in time
            startTimeoutThenShowText();
          },
          child:

              /// Show text only when the button is enabled
              Visibility(
            visible: _btnEnabled,
            child: Text('Verification Code',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
        )
      ],
    );
  }

  /// Toggle the text state
  /// btnEnabled is optional and the default value is true
  void _toggleTextState([bool btnEnabled = true]) {
    setState(() {
      _btnEnabled = btnEnabled;
    });
  }

  /// Starts a count down timer that executes the function after hitting 0
  Timer startTimeoutThenShowText() {
    return Timer(timeout, _toggleTextState);
  }
}

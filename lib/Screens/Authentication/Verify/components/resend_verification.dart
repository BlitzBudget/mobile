import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../data/authentication.dart';

class ResendVerification extends StatelessWidget {
  final String email;
  RestDataSource _restDataSource = RestDataSource();

  const ResendVerification({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Resend ",
          style: TextStyle(color: primaryColor),
        ),
        GestureDetector(
          onTap: () async {
            await _restDataSource.resendVerificationCode(email);
          },
          child: Text(
            "Verification Code",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

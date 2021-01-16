import 'package:flutter/material.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String email, password;

  /// In the constructor, require a Todo.
  ForgotPasswordScreen({Key key, this.email = '', this.password = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, password: password),
    );
  }
}

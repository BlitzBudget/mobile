import 'package:flutter/material.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const ForgotPasswordScreen({Key key, this.email = '', this.password = ''})
      : super(key: key);

  final String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, password: password),
    );
  }
}

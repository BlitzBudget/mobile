import 'package:flutter/material.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const SignUpScreen({Key key, @required this.email, @required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, password: password),
    );
  }
}

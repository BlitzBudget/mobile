import 'package:flutter/material.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  final String email;
  final String password;

 /// In the constructor, require a Todo.
  SignUpScreen({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, password: password),
    );
  }
}

import 'package:flutter/material.dart';
import 'components/body.dart';

class VerifyScreen extends StatelessWidget {
  final String email, password;
  final bool useVerifyURL;

  // In the constructor, require a Todo.
  VerifyScreen(
      {Key key,
      @required this.email,
      @required this.password,
      this.useVerifyURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, password: password, useVerifyURL: useVerifyURL),
    );
  }
}

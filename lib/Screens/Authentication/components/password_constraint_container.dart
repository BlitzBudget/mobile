import 'package:flutter/material.dart';
import '../../../constants.dart';

class PasswordConstraint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.8,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Text("Minimum length is 8 characters.",
              style: TextStyle(color: primaryColor, fontSize: 10),
              textAlign: TextAlign.left)
        ]));
  }
}

import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class PasswordConstraint extends StatelessWidget {
  /// In the constructor,
  const PasswordConstraint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.8,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
          Text('Minimum length is 8 characters.',
              style: TextStyle(color: primaryColor, fontSize: 10),
              textAlign: TextAlign.left)
        ]));
  }
}

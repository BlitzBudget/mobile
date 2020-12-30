import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/rounded_button.dart';
import '../../Login/login_screen.dart';
import 'background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final welcomeToBlitzBudget = 'WELCOME TO BlitzBudget';
    final startButton = 'START';

    /// This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              welcomeToBlitzBudget,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              'assets/icons/chat.svg',
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: startButton,
              press: () {
                /// Navigate to the second screen using a named route.
                Navigator.pushNamed(context, loginRoute);
              },
            )
          ],
        ),
      ),
    );
  }
}

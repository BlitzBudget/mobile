import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/constants/theme.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/rounded_button.dart';
import 'background.dart';

class Body extends StatelessWidget {
  /// In the constructor
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const welcomeToBlitzBudget = 'WELCOME TO BlitzBudget';
    const startButton = 'GET STARTED';

    /// This size provide us total height and width of our screen
    return Background(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/business-name/business-name-logo.png',
                scale: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 48),
                  child: Text.rich(TextSpan(
                    text: welcomeToBlitzBudget,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 58,
                        fontWeight: FontWeight.w600),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Fully coded Flutter widgets and screens.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w200)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  text: startButton,
                  textColor: ArgonColors.text,
                  color: ArgonColors.secondary,
                  press: () {
                    Navigator.pushNamed(context, loginRoute);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

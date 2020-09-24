import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/Screens/Welcome/welcome_screen.dart';
import 'package:mobile_blitzbudget/constants.dart';

void main() => runApp(MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'BlitzBudget',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.green,
        primaryColor: kPrimaryColor,
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          // Instead of letting Cupertino widgets auto-adapt to the Material
          // theme (which is green), this app will use a different theme
          // for Cupertino (which is blue by default).
          data: CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      routes: routes,
      //home: WelcomeScreen(),
    );
  }
}

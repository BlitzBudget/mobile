import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/constants.dart';
import 'package:mobile_blitzbudget/data/rest_ds.dart';
import 'package:mobile_blitzbudget/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String initialRoutes = '/';
void main() async => runApp(MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'BlitzBudget',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.green,
        primaryColor: primaryColor,
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
      initialRoute: initialRoute,
      routes: routes,
      // Navigate to the second screen using a named route.
      home: (token == null ? Navigator.pushNamed(context, initialRoute) : Navigator.pushNamed(context, dashboardRoute)),
    );
  }
}

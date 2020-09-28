import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/constants.dart';
import 'package:mobile_blitzbudget/data/rest_ds.dart';
import 'package:mobile_blitzbudget/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//void main() async => runApp(MyAdaptingApp());

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = new FlutterSecureStorage();
    // Read value
    String token = await storage.read(key: 'token');
    String homePage = token == null ?  initialRoute : dashboardRoute;
    runApp(MyAdaptingApp(
        homePage: homePage,
    ));
}

class MyAdaptingApp extends StatelessWidget {
  final String homePage;

  // Constructor
  MyAdaptingApp({this.homePage});

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
      initialRoute: homePage,
      routes: routes,
    );
  }
}

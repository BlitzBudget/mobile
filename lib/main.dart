import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app/constants/constants.dart';
import 'app/routes.dart';
import 'injection_container.dart' as dependency_injection;

/// Global Navigation Key
///
/// Use it to navigate through the app without context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();
  final homeRoute = initialRoute;
  runApp(BlitzBudgetApp(
    homeRoute: homeRoute,
  ));
}

class BlitzBudgetApp extends StatelessWidget {
  /// Constructor
  const BlitzBudgetApp({Key key, this.homeRoute}) : super(key: key);

  final String homeRoute;
  static const appName = 'BlitzBudget';

  @override
  Widget build(context) {
    /// Either Material or Cupertino widgets work in either Material or Cupertino
    /// Apps.
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: appName,
      theme: ThemeData(
        /// Use the green theme for Material widgets.
        primarySwatch: Colors.green,
        primaryColor: primaryColor,
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          /// Instead of letting Cupertino widgets auto-adapt to the Material
          /// theme (which is green), this app will use a different theme
          /// for Cupertino (which is blue by default).
          data: const CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      initialRoute: homeRoute,
      routes: routes,
    );
  }
}

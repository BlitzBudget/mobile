import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app/constants/constants.dart';
import 'app/routes.dart';
import 'domain/repositories/authentication/auth_token_repository.dart';

/// Global Navigation Key
///
/// Use it to navigate through the app without context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthTokenRepository authTokenRepository;

  /// Read value
  var token = await authTokenRepository.readAuthToken();
  var homeRoute = token.isLeft() ? initialRoute : dashboardRoute;
  runApp(BlitzBudgetApp(
    homeRoute: homeRoute,
  ));
}

class BlitzBudgetApp extends StatelessWidget {
  final String homeRoute;
  static final appName = 'BlitzBudget';

  /// Constructor
  BlitzBudgetApp({this.homeRoute});

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
          data: CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      initialRoute: homeRoute,
      routes: routes,
    );
  }
}

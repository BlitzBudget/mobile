import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/dashboard_screen.dart';
import 'package:mobile_blitzbudget/Screens/Welcome/welcome_screen.dart';
import 'package:mobile_blitzbudget/constants.dart';

final routes = {
  welcomeRoute :         (BuildContext context) => new WelcomeScreen(),
  loginRoute :         (BuildContext context) => new WelcomeScreen(),
  signupRoute :         (BuildContext context) => new WelcomeScreen(),
  dashboardRoute :         (BuildContext context) => new DashboardScreen(),
  initialRoute :          (BuildContext context) => new WelcomeScreen(),
};

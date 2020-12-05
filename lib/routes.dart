import 'package:flutter/material.dart';

import 'Screens/Dashboard/dashboard_screen.dart';
import 'Screens/Authentication/Welcome/welcome_screen.dart';
import 'Screens/Authentication/Login/login_screen.dart';
import 'Screens/Authentication/Signup/signup_screen.dart';
import 'constants.dart';

final routes = {
  welcomeRoute: (BuildContext context) => new WelcomeScreen(),
  loginRoute: (BuildContext context) => new LoginScreen(),
  signupRoute: (BuildContext context) => new SignUpScreen(),
  dashboardRoute: (BuildContext context) => new DashboardScreen(),
  initialRoute: (BuildContext context) => new WelcomeScreen(),
};

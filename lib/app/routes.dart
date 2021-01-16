import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'screens/authentication/forgot-password/forgot_password_screen.dart';
import 'screens/authentication/login/login_screen.dart';
import 'screens/authentication/welcome/welcome_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

final routes = {
  welcomeRoute: (BuildContext context) => WelcomeScreen(),
  loginRoute: (BuildContext context) => LoginScreen(),
  dashboardRoute: (BuildContext context) => DashboardScreen(),
  forgotPasswordRoute: (BuildContext context) => ForgotPasswordScreen(),
  initialRoute: (BuildContext context) => WelcomeScreen(),
};

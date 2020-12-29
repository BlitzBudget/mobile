import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/authentication/welcome/welcome_screen.dart';
import 'screens/authentication/login/login_screen.dart';
import 'screens/authentication/signup/signup_screen.dart';
import 'screens/authentication/verify/verify_screen.dart';
import 'screens/authentication/forgot-password/forgot_password_screen.dart';
import 'constants/constants.dart';

final routes = {
  welcomeRoute: (BuildContext context) => new WelcomeScreen(),
  loginRoute: (BuildContext context) => new LoginScreen(),
  signupRoute: (BuildContext context) => new SignUpScreen(),
  dashboardRoute: (BuildContext context) => new DashboardScreen(),
  verifyRoute: (BuildContext context) => new VerifyScreen(),
  forgotPasswordRoute: (BuildContext context) => new ForgotPasswordScreen(),
  initialRoute: (BuildContext context) => new WelcomeScreen(),
};

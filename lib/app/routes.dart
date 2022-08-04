import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/screens/dashboard/transaction/add/add_transaction_screen.dart';

import 'constants/constants.dart';
import 'screens/authentication/forgot-password/forgot_password_screen.dart';
import 'screens/authentication/login/login_screen.dart';
import 'screens/authentication/welcome/welcome_screen.dart';
import 'screens/dashboard/main/dashboard_screen.dart';

final routes = {
  welcomeRoute: (BuildContext context) => const WelcomeScreen(),
  loginRoute: (BuildContext context) => const LoginScreen(),
  dashboardRoute: (BuildContext context) => const DashboardScreen(),
  forgotPasswordRoute: (BuildContext context) => const ForgotPasswordScreen(),
  initialRoute: (BuildContext context) => const WelcomeScreen(),
  addTransactionRoute: (BuildContext context) => const AddTransactionScreen(),
};

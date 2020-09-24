import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/dashboard_screen.dart';
import 'package:mobile_blitzbudget/Screens/Welcome/welcome_screen.dart';

final routes = {
  '/welcome':         (BuildContext context) => new WelcomeScreen(),
  '/dashboard':         (BuildContext context) => new DashboardScreen(),
  '/' :          (BuildContext context) => new WelcomeScreen(),
};

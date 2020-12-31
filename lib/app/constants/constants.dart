import 'package:flutter/material.dart';

/*const primaryColor = Color(0xFF00BCD4);
const primaryLightColor = Color(0xFF009AAE);
const primaryDisabledColor = Color(0xFF00BCD4);*/
const primaryColor = Color(0xFF6F35A5);
const primaryLightColor = Color(0xFFF1E6FF);
const primaryDisabledColor = Color(0xFF7848A5);
const secondaryColor = Color(0xFF6C757D);

// Routes
const String dashboardRoute = '/dashboard';
const String loginRoute = '/login';
const String signupRoute = '/signup';
const String initialRoute = '/';
const String welcomeRoute = '/welcome';
const String verifyRoute = '/verify';
const String forgotPasswordRoute = '/forgot-password';

// Profile Tab
const String logoutDescription = "Are you sure?";
const String logoutTitle = 'Log out';
const String logoutConfirmation = 'Log out?';
const String logoutButton = 'Logout';
const String logoutCancel = 'Cancel';

/// Authentication Page Regular Expresiion validations
RegExp passwordExp = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
RegExp emailExp = RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");

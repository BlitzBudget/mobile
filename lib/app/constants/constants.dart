import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(94, 114, 228, 1);
const primaryLightColor = Color.fromRGBO(247, 250, 252, 1);
const primaryDisabledColor = Color.fromRGBO(247, 250, 252, 1);
const secondaryColor = Color.fromRGBO(247, 250, 252, 1);

// Routes
const String dashboardRoute = '/dashboard';
const String loginRoute = '/login';
const String signupRoute = '/signup';
const String initialRoute = '/';
const String welcomeRoute = '/welcome';
const String verifyRoute = '/verify';
const String forgotPasswordRoute = '/forgot-password';

const String addTransactionRoute = '/add-transactions';
const String addWalletRoute = '/add-wallet';

// Profile Tab
const String logoutDescription = 'Are you sure?';
const String logoutTitle = 'Log out';
const String logoutConfirmation = 'Log out?';
const String logoutButton = 'Logout';
const String logoutCancel = 'Cancel';

/// Authentication Page Regular Expresiion validations
RegExp passwordExp = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');

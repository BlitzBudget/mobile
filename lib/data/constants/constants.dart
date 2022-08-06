// Date format
const String dateFormatStartAndEndDate = 'yyyy-MM-dd';

/// Base URL
const String baseURL = 'https://api.blitzbudget.com';

/// Authentication URLs
const String refreshTokenURL = '$baseURL/profile/refresh-token';
const String loginURL = '$baseURL/profile/sign-in';
const String signupURL = '$baseURL/profile/sign-up';
const String forgotPasswordURL = '$baseURL/profile/forgot-password';
const String confirmSignupURL = '$baseURL/profile/confirm-sign-up';
const String confirmForgotPasswordURL =
    '$baseURL/profile/confirm-forgot-password';
const String resendVerificationCodeURL =
    '$baseURL/profile/resend-confirmation-code';
const String userAttributesURL = '$baseURL/profile/user-attribute';
const String changePasswordURL = '$baseURL/profile/change-password';

/// Dashboard URLs
const String budgetURL = '$baseURL/budgets';
const String deleteCategoryURL = '$baseURL/categories/delete';
const String goalURL = '$baseURL/goals';
const String overviewURL = '$baseURL/overview';
const String walletURL = '$baseURL/wallet';
const String transactionURL = '$baseURL/transactions';
const String recurringTransactionURL = '$baseURL/recurring-transaction';
const String deleteItemURL = '$baseURL/delete-item';

/// Header for API calls
Map<String, String> headers = {
  'Content-type': 'application/json;charset=UTF-8',
  'Accept': 'application/json'
};

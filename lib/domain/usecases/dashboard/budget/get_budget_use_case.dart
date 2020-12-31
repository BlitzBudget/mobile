import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

class GetBudgetUseCase {
  BudgetRepository budgetRepository;
  Future<dynamic> getBudget() {
    // TODO
    /*/// Get from shared preferences
    final String _defaultWallet = _prefs.getString(constants.defaultWallet);
    final String _startsWithDate =
        await dashboardUtils.fetchStartsWithDate(_prefs);
    final String _endsWithDate = await dashboardUtils.fetchEndsWithDate(_prefs);

    // Read [_userAttributes] from User Attributes
    final String _userAttributes =
        await _storage.read(key: constants.userAttributes);
    // Decode the json user
    Map<String, dynamic> _user = jsonDecode(_userAttributes);
    developer.log('User Attributes retrieved for: ${_user["userid"]}');

    // JSON for Get budget [_jsonForGetBudget]
    Map<String, dynamic> _jsonForGetBudget = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetBudget["walletId"] = _defaultWallet;
    } else {
      _jsonForGetBudget["userId"] = _user["userid"];
    }

    developer.log(
        "The Map for getting the budget is  ${_jsonForGetBudget.toString()}");

    budgetRepository.get();*/
  }
}

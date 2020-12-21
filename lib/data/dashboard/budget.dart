import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

import '../../utils/network_util.dart';
import '../authentication.dart';
import '../../constants.dart';

class BudgetRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();

  static final _budgetURL = RestDataSource.baseURL + "/budgets";

  /*let values = {};
        if (isNotEmpty(window.currentUser.walletId)) {
            values.walletId = window.currentUser.walletId;
        } else {
            values.userId = window.currentUser.financialPortfolioId;
        }
        let y = window.chosenDate.getFullYear(),
            m = window.chosenDate.getMonth();
        values.startsWithDate = new Date(y, m, 1);
        values.endsWithDate = new Date(y, m + 1, 0);*/

  /// Get Budgets
  Future<void> get() async {
    // Read value
    final String value = await _storage.read(key: userAttributes);
    debugPrint('User Attributes retrieved: $value');
    /*return _netUtil
        .get(_budgetURL,
            body: jsonEncode({
              "walletId": email,
              "userId": password,
              "startsWithDate": _checkPassword,
              "endsWithDate": _checkPassword
            }),
            headers: RestDataSource.headers)
        .then((dynamic res) {

        });*/
  }

  /// Update Budget
  Future<void> update() {}

  /// Delete Budget
  Future<void> delete() {}
}

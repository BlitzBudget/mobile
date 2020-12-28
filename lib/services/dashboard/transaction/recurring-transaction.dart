import '../../utils/network_util.dart';
import '../authentication.dart' as authentication;
import '../../constants/constants.dart' as constants;

class RecurringTransactionRestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _recurringTransactionURL =
      authentication.baseURL + '/recurring-transaction';

  /// Update Transaction
  Future<void> update(String walletId, String transactionId,
      {List<String> tags, String description, String amount}) {
    // JSON for Get budget [_jsonForUpdateRecurTransaction]
    Map<String, dynamic> _jsonForUpdateRecurTransaction = {
      'walletId': walletId,
      'transactionId': transactionId
    };

    if (isNotEmpty(tags)) {
      _jsonForUpdateRecurTransaction["tags"] = tags;
    }

    if (isNotEmpty(description)) {
      _jsonForUpdateRecurTransaction["description"] = description;
    }

    if (isNotEmpty(amount)) {
      _jsonForUpdateRecurTransaction["amount"] = amount;
    }

    if (isNotEmpty(categoryId)) {
      _jsonForUpdateRecurTransaction["category"] = categoryId;
    }

    if (isNotEmpty(accountId)) {
      _jsonForUpdateRecurTransaction["account"] = accountId;
    }

    developer.log(
        "The Map for patching the budget is  ${_jsonForUpdateRecurTransaction.toString()}");

    return _netUtil
        .patch(_recurringTransactionURL,
            body: jsonEncode(_jsonForUpdateRecurTransaction),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }
}

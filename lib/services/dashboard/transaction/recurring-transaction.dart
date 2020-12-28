import '../../utils/network_util.dart';
import '../authentication.dart' as authentication;
import '../../constants/constants.dart' as constants;

class RecurringTransactionRestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _recurringTransactionURL =
      authentication.baseURL + '/recurring-transaction';

  /// Update Transaction
  Future<void> update(RecurringTransaction updateRecurringTransaction) {

    developer.log(
        "The Map for patching the recurring transactions is  ${updateRecurringTransaction.toString()}");

    return _netUtil
        .patch(_recurringTransactionURL,
            body: jsonEncode(updateRecurringTransaction.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the recurring transactions is $res');
    });
  }
}

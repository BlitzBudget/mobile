import '../../data/utils/network_helper.dart';
import '../remote/authentication_remote_data_source.dart' as authentication;
import '../../app/constants/constants.dart' as constants;

abstract class RecurringTransactionRemoteDataSource {
  Future<void> update(RecurringTransaction updateRecurringTransaction);
}

class RecurringTransactionRemoteDataSourceImpl
    implements RecurringTransactionRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _recurringTransactionURL =
      authentication.baseURL + '/recurring-transaction';

  /// Update Transaction
  @override
  Future<void> update(RecurringTransaction updateRecurringTransaction) {
    developer.log(
        "The Map for patching the recurring transactions is  ${updateRecurringTransaction.toString()}");

    return _netUtil
        .patch(_recurringTransactionURL,
            body: jsonEncode(updateRecurringTransaction.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the recurring transactions is $res');
      //TODO
    });
  }
}

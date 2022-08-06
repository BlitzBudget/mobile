import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

class TransactionResponseModel extends TransactionResponse {
  const TransactionResponseModel({List<Transaction>? transactions})
      : super(
          transactions: transactions,
        );

  factory TransactionResponseModel.fromJSON(
      List<dynamic> transactionResponseModel) {
    /// Convert transactions from the response JSON to List<Transaction>
    /// If Empty then return an empty object list
    final convertedTransactions = List<Transaction>.from(
        transactionResponseModel
            .map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)));

    return TransactionResponseModel(transactions: convertedTransactions);
  }
}

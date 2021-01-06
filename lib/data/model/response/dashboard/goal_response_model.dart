import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../date_model.dart';

class GoalResponseModel extends GoalResponse {
  GoalResponseModel(
      {List<Goal> goals,
      List<BankAccount> bankAccounts,
      List<Date> dates,
      Wallet wallet})
      : super(
            goals: goals,
            bankAccounts: bankAccounts,
            dates: dates,
            wallet: wallet);

  factory GoalResponseModel.fromJSON(Map<String, dynamic> goalResponseModel) {
    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    var responseGoals = goalResponseModel['Goal'] as List;
    var convertedGoals = List<Goal>.from(responseGoals?.map<dynamic>(
            (dynamic model) =>
                GoalModel.fromJSON(model as Map<String, dynamic>)) ??
        <Goal>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    var responseBankAccounts = goalResponseModel['BankAccount'] as List;
    var convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>((dynamic model) =>
                BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    var responseDate = goalResponseModel['Date'] as List;
    var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
            (dynamic model) =>
                DateModel.fromJSON(model as Map<String, dynamic>)) ??
        <Date>[]);

    dynamic responseWallet = goalResponseModel['Wallet'];
    Wallet convertedWallet;

    /// Check if the response is a string or a list
    ///
    /// If string then convert them into a wallet
    /// If List then convert them into list of wallets and take the first wallet.
    if (responseWallet is Map) {
      convertedWallet =
          WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
    } else if (responseWallet is List) {
      var convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
          (dynamic model) =>
              WalletModel.fromJSON(model as Map<String, dynamic>)));

      convertedWallet = convertedWallets[0];
    }
    return GoalResponseModel(
        goals: convertedGoals,
        bankAccounts: convertedBankAccounts,
        dates: convertedDates,
        wallet: convertedWallet);
  }
}

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
  const GoalResponseModel(
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
    final responseGoals = goalResponseModel['Goal'];
    final convertedGoals = List<Goal>.from(responseGoals?.map<dynamic>(
            (dynamic model) =>
                GoalModel.fromJSON(model)) ??
        <Goal>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    final responseBankAccounts = goalResponseModel['BankAccount'];
    final convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>((dynamic model) =>
                BankAccountModel.fromJSON(model)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    final responseDate = goalResponseModel['Date'];
    final convertedDates = List<Date>.from(responseDate?.map<dynamic>(
            (dynamic model) =>
                DateModel.fromJSON(model)) ??
        <Date>[]);

    final responseWallet = goalResponseModel['Wallet'];
    Wallet convertedWallet;

    /// Check if the response is a string or a list
    ///
    /// If string then convert them into a wallet
    /// If List then convert them into list of wallets and take the first wallet.
    if (responseWallet is Map) {
      convertedWallet =
          WalletModel.fromJSON(responseWallet);
    } else if (responseWallet is List) {
      final convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
          (dynamic model) =>
              WalletModel.fromJSON(model)));

      convertedWallet = convertedWallets[0];
    }
    return GoalResponseModel(
        goals: convertedGoals,
        bankAccounts: convertedBankAccounts,
        dates: convertedDates,
        wallet: convertedWallet);
  }
}

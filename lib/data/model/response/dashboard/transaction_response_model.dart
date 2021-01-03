import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class TransactionResponseModel extends TransactionResponse {
  TransactionResponseModel(
      {List<Transaction> transactions,
      List<Budget> budgets,
      List<Category> categories,
      List<BankAccount> bankAccounts,
      List<RecurringTransaction> recurringTransactions,
      List<Date> dates,
      Wallet wallet})
      : super(
            transactions: transactions,
            budgets: budgets,
            categories: categories,
            bankAccounts: bankAccounts,
            recurringTransactions: recurringTransactions,
            dates: dates,
            wallet: wallet);
}

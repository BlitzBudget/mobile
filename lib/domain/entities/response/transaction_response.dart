import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../date.dart';

class TransactionResponse extends Equatable {
  const TransactionResponse(
      {this.transactions,
      this.budgets,
      this.categories,
      this.bankAccounts,
      this.recurringTransactions,
      this.dates,
      this.wallet,
      this.incomeTotal,
      this.expenseTotal,
      this.balance});

  final List<Transaction>? transactions;
  final List<Budget>? budgets;
  final List<Category>? categories;
  final List<BankAccount>? bankAccounts;
  final List<RecurringTransaction>? recurringTransactions;
  final List<Date>? dates;
  final Wallet? wallet;
  final double? incomeTotal;
  final double? expenseTotal;
  final double? balance;

  @override
  List<Object?> get props => [
        transactions,
        budgets,
        categories,
        bankAccounts,
        recurringTransactions,
        dates,
        wallet
      ];
}

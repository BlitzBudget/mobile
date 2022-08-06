import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class OverviewResponse extends Equatable {
  const OverviewResponse(
      {this.transactions, this.budgets, this.categories, this.wallet});

  final List<Transaction>? transactions;
  final List<Budget>? budgets;
  final List<Category>? categories;
  final Wallet? wallet;

  @override
  List<Object?> get props => [transactions, budgets, categories, wallet];
}

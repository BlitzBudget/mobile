import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class GoalResponse extends Equatable {
  final List<Goal> goals;
  final List<BankAccount> bankAccounts;
  final List<Date> dates;
  final Wallet wallet;

  GoalResponse({this.goals, this.bankAccounts, this.dates, this.wallet});

  @override
  List<Object> get props => [goals, bankAccounts, dates, wallet];
}

import 'package:equatable/equatable.dart';

class Date extends Equatable {
  final String walletId;
  final String dateId;
  final double incomeTotal;
  final double expenseTotal;
  final double balance;

  Date(
      {this.walletId,
      this.dateId,
      this.incomeTotal,
      this.expenseTotal,
      this.balance});

  @override
  List<Object> get props =>
      [walletId, dateId, incomeTotal, expenseTotal, balance];
}

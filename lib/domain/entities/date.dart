import 'package:equatable/equatable.dart';

class Date extends Equatable {
  const Date(
      {this.walletId,
      this.dateId,
      this.incomeTotal,
      this.expenseTotal,
      this.balance});

  final String? walletId;
  final String? dateId;
  final double? incomeTotal;
  final double? expenseTotal;
  final double? balance;

  @override
  List<Object?> get props =>
      [walletId, dateId, incomeTotal, expenseTotal, balance];
}

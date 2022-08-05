import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

class TransactionResponse extends Equatable {
  const TransactionResponse({this.transactions});

  final List<Transaction>? transactions;

  @override
  List<Object?> get props => [transactions];
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

abstract class BankAccountRepository {
  Future<Either<Failure, void>> update(BankAccount updateBankAccount);

  Future<Either<Failure, void>> add(BankAccount addBankAccount);

  Future<Either<Failure, void>> delete(
      {@required String walletId, @required String account});
}

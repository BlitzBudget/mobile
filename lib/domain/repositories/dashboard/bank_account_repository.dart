import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';

abstract class BankAccountRepository {
  Future<Either<Failure, void>> update(BankAccountModel updateBankAccount);

  Future<Either<Failure, void>> add(BankAccountModel addBankAccount);

  Future<Either<Failure, void>> delete(String walletId, String account);
}

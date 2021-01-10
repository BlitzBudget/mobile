import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';

class BankAccountRepositoryImpl extends BankAccountRepository {
  final BankAccountRemoteDataSource bankAccountRemoteDataSource;

  BankAccountRepositoryImpl({
    @required this.bankAccountRemoteDataSource,
  });

  @override
  Future<Either<Failure, void>> update(BankAccount updateBankAccount) async {
    try {
      return Right(await bankAccountRemoteDataSource
          .update(updateBankAccount as BankAccountModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(BankAccount addBankAccount) async {
    try {
      return Right(await bankAccountRemoteDataSource
          .add(addBankAccount as BankAccountModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> delete(
      {@required String walletId, @required String account}) async {
    try {
      return Right(await bankAccountRemoteDataSource.delete(
          walletId: walletId, account: account));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}

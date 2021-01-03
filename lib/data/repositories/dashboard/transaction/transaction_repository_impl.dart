import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource transactionRemoteDataSource;

  TransactionRepositoryImpl({@required this.transactionRemoteDataSource});

  @override
  Future<Either<Failure, TransactionResponse>> get(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId) async {
    try {
      return Right(await transactionRemoteDataSource.get(
          startsWithDate, endsWithDate, defaultWallet, userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(Transaction updateTransaction) async {
    try {
      return Right(await transactionRemoteDataSource
          .update(updateTransaction as TransactionModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(Transaction addTransaction) async {
    try {
      return Right(await transactionRemoteDataSource
          .update(addTransaction as TransactionModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}

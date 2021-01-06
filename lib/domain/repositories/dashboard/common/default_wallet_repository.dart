import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

abstract class DefaultWalletRepository {
  Future<Either<Failure, String>> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}

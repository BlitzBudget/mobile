import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<Wallet>?>> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet,
      required String? userId});
  Future<Either<Failure, void>> add(
      {required String? userId, required String? currency});
  Future<Either<Failure, void>> update(Wallet updateWallet);
  Future<Either<Failure, void>> delete(
      {required String walletId, required String? userId});
}

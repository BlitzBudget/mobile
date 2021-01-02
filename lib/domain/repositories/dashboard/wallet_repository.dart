import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';

abstract class WalletRepository {
  Future<Either<Failure, void>> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);
  Future<Either<Failure, void>> add(String userId, String currency);
  Future<Either<Failure, void>> update(WalletModel updateWallet);
  Future<Either<Failure, void>> delete(String walletId, String userId);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

class UpdateWalletUseCase {
  WalletRepository walletRepository;

  Future<Either<Failure, void>> update({@required Wallet updateWallet}) async {
    return await walletRepository.update(updateWallet);
  }
}

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

  /// Updates the category id
  Future<Either<Failure, void>> updateCurrency(
      String currency, String walletId) async {
    final wallet = Wallet(walletId: walletId, currency: currency);
    return await update(updateWallet: wallet);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateWalletName(
      String name, String walletId) async {
    final wallet = Wallet(walletId: walletId, walletName: name);
    return await update(updateWallet: wallet);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

import '../../use_case.dart';

class UpdateWalletUseCase extends UseCase {
  final WalletRepository walletRepository;

  UpdateWalletUseCase({@required this.walletRepository});

  Future<Either<Failure, void>> update({@required Wallet updateWallet}) async {
    return await walletRepository.update(updateWallet);
  }

  /// Updates the update currenct=y
  Future<Either<Failure, void>> updateCurrency(
      {@required String currency, @required String walletId}) async {
    final wallet = Wallet(walletId: walletId, currency: currency);
    return await update(updateWallet: wallet);
  }

  /// Updates the wallet name
  Future<Either<Failure, void>> updateWalletName(
      {@required String name, @required String walletId}) async {
    final wallet = Wallet(walletId: walletId, walletName: name);
    return await update(updateWallet: wallet);
  }
}

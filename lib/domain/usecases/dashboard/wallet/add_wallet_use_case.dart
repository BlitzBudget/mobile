import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

class AddWalletUseCase {
  WalletRepository walletRepository;
  UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, void>> add({@required String currency}) async {
    /// Read User Attributes
    var user = await userAttributesRepository.readUserAttributes();
    var userId = user.userId;

    return await walletRepository.add(userId, currency);
  }
}

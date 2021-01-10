import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

import '../../use_case.dart';

class AddWalletUseCase extends UseCase {
  final WalletRepository walletRepository;
  final UserAttributesRepository userAttributesRepository;

  AddWalletUseCase(
      {@required this.walletRepository,
      @required this.userAttributesRepository});

  Future<Either<Failure, void>> add({@required String currency}) async {
    var userResponse = await userAttributesRepository.readUserAttributes();
    String userId;
    if (userResponse.isRight()) {
      userId = userResponse.getOrElse(null).userId;
    } else {
      return Left(EmptyResponseFailure());
    }

    return await walletRepository.add(userId: userId, currency: currency);
  }
}

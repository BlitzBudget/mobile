import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

import '../../use_case.dart';

class DeleteWalletUseCase extends UseCase {
  final WalletRepository walletRepository;
  final UserAttributesRepository userAttributesRepository;

  DeleteWalletUseCase(
      {@required this.walletRepository,
      @required this.userAttributesRepository});

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    String userId;
    var userResponse = await userAttributesRepository.readUserAttributes();
    if (userResponse.isRight()) {
      userId = userResponse.getOrElse(null).userId;
    } else {
      return Left(EmptyResponseFailure());
    }

    return await walletRepository.delete(userId: userId, walletId: itemId);
  }
}

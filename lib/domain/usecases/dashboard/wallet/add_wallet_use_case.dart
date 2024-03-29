import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

import '../../use_case.dart';

class AddWalletUseCase extends UseCase {
  AddWalletUseCase(
      {required this.walletRepository, required this.userAttributesRepository});

  final WalletRepository? walletRepository;
  final UserAttributesRepository? userAttributesRepository;

  Future<Either<Failure, void>> add(
      {required String? currency, required String? name}) async {
    final userResponse = await userAttributesRepository!.readUserAttributes();
    String? userId;
    if (userResponse.isRight()) {
      userId = userResponse.getOrElse(() => const User())!.userId;
    } else {
      return Left(EmptyResponseFailure());
    }

    return walletRepository!
        .add(userId: userId, currency: currency, name: name);
  }
}

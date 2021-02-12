import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

import '../../use_case.dart';

class FetchWalletUseCase extends UseCase {
  FetchWalletUseCase(
      {@required this.walletRepository,
      @required this.startsWithDateRepository,
      @required this.endsWithDateRepository,
      @required this.defaultWalletRepository,
      @required this.userAttributesRepository});

  final WalletRepository walletRepository;
  final StartsWithDateRepository startsWithDateRepository;
  final EndsWithDateRepository endsWithDateRepository;
  final DefaultWalletRepository defaultWalletRepository;
  final UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, List<Wallet>>> fetch() async {
    final startsWithDate = await startsWithDateRepository.readStartsWithDate();
    final endsWithDate = await endsWithDateRepository.readEndsWithDate();
    final defaultWallet = await defaultWalletRepository.readDefaultWallet();
    String userId, wallet;

    /// Get User id only when the default wallet is empty
    if (defaultWallet.isLeft()) {
      final userResponse = await userAttributesRepository.readUserAttributes();
      if (userResponse.isRight()) {
        userId = userResponse.getOrElse(null).userId;
      } else {
        return Left(EmptyResponseFailure());
      }
    } else {
      wallet = defaultWallet.getOrElse(null);
    }

    return walletRepository.fetch(
        startsWithDate: startsWithDate,
        endsWithDate: endsWithDate,
        defaultWallet: wallet,
        userId: userId);

    // TODO if default wallet is empty then store them
  }
}

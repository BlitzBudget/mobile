import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

import '../../use_case.dart';

class FetchTransactionUseCase extends UseCase {
  final TransactionRepository transactionRepository;
  final StartsWithDateRepository startsWithDateRepository;
  final EndsWithDateRepository endsWithDateRepository;
  final DefaultWalletRepository defaultWalletRepository;
  final UserAttributesRepository userAttributesRepository;

  FetchTransactionUseCase(
      {@required this.transactionRepository,
      @required this.startsWithDateRepository,
      @required this.endsWithDateRepository,
      @required this.defaultWalletRepository,
      @required this.userAttributesRepository});

  Future<Either<Failure, TransactionResponse>> fetch() async {
    var startsWithDate = await startsWithDateRepository.readStartsWithDate();
    var endsWithDate = await endsWithDateRepository.readEndsWithDate();
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();
    String userId;

    /// Get User id only when the default wallet is empty
    if (defaultWallet.isLeft()) {
      var userResponse = await userAttributesRepository.readUserAttributes();
      if (userResponse.isRight()) {
        userId = userResponse.getOrElse(null).userId;
      } else {
        return Left(EmptyResponseFailure());
      }
    }

    return await transactionRepository.fetch(
        startsWithDate, endsWithDate, defaultWallet.getOrElse(null), userId);

    // TODO if default wallet is empty then store them
  }
}

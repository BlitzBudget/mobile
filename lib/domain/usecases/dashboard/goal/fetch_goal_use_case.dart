import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';

import '../../use_case.dart';

class FetchGoalUseCase extends UseCase {
  FetchGoalUseCase(
      {required this.goalRepository,
      required this.startsWithDateRepository,
      required this.endsWithDateRepository,
      required this.defaultWalletRepository,
      required this.userAttributesRepository});

  late final GoalRepository goalRepository;
  late final StartsWithDateRepository startsWithDateRepository;
  late final EndsWithDateRepository endsWithDateRepository;
  late final DefaultWalletRepository defaultWalletRepository;
  late final UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, GoalResponse>> fetch() async {
    final startsWithDate = await startsWithDateRepository.readStartsWithDate();
    final endsWithDate = await endsWithDateRepository.readEndsWithDate();
    final defaultWallet = await defaultWalletRepository.readDefaultWallet();
    String? userId, wallet;

    /// Get User id only when the default wallet is empty
    if (defaultWallet.isLeft()) {
      final userResponse = await userAttributesRepository.readUserAttributes();
      if (userResponse.isRight()) {
        userId = userResponse.getOrElse(() => const User())!.userId;
      } else {
        return Left(EmptyResponseFailure());
      }
    } else {
      wallet = defaultWallet.getOrElse(() => '');
    }

    return goalRepository.fetch(
        startsWithDate: startsWithDate,
        endsWithDate: endsWithDate,
        defaultWallet: wallet,
        userId: userId);
    // TODO if default wallet is empty then store them
  }
}

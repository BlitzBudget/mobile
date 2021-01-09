import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

import '../../use_case.dart';

class DeleteBudgetUseCase extends UseCase {
  final DeleteItemRepository deleteItemRepository;
  final DefaultWalletRepository defaultWalletRepository;

  DeleteBudgetUseCase(
      {@required this.deleteItemRepository,
      @required this.defaultWalletRepository});

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return await deleteItemRepository.delete(
        defaultWallet.getOrElse(null), itemId);
  }
}

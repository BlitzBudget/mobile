import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

import '../../use_case.dart';

class DeleteTransactionUseCase extends UseCase {
  DeleteTransactionUseCase(
      {required this.deleteItemRepository,
      required this.defaultWalletRepository});

  final DeleteItemRepository? deleteItemRepository;
  final DefaultWalletRepository? defaultWalletRepository;

  Future<Either<Failure, void>> delete({required String itemID}) async {
    final defaultWallet = await defaultWalletRepository!.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return deleteItemRepository!
        .delete(walletID: defaultWallet.getOrElse(() => ''), itemID: itemID);
  }
}

import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/category_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

import '../../use_case.dart';

class DeleteCategoryUseCase extends UseCase {
  DeleteCategoryUseCase(
      {required this.categoryRepository,
      required this.defaultWalletRepository});

  final CategoryRepository? categoryRepository;
  final DefaultWalletRepository? defaultWalletRepository;

  Future<Either<Failure, void>> delete({required String itemId}) async {
    final defaultWallet = await defaultWalletRepository!.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return categoryRepository!
        .delete(walletId: defaultWallet.getOrElse(() => ''), category: itemId);
  }
}

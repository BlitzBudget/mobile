import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/category_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class DeleteBudgetUseCase {
  CategoryRepository categoryRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> delete(String itemId) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return await categoryRepository.delete(
        defaultWallet.getOrElse(null), itemId);
  }
}

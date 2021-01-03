import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

class DeleteBudgetUseCase {
  DeleteItemRepository deleteItemRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> delete(String itemId) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    return await deleteItemRepository.delete(defaultWallet, itemId);
  }
}

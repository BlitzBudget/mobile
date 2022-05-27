import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/common/delete_item_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

class DeleteItemRepositoryImpl implements DeleteItemRepository {
  DeleteItemRepositoryImpl({required this.deleteItemRemoteDataSource});

  late final DeleteItemRemoteDataSource deleteItemRemoteDataSource;

  @override
  Future<Either<Failure, void>> delete(
      {required String walletID, required String itemID}) async {
    try {
      return Right(await deleteItemRemoteDataSource.delete(
          walletId: walletID, itemId: itemID));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}

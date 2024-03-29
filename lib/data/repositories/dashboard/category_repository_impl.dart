import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/category_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required this.categoryRemoteDataSource});

  final CategoryRemoteDataSource? categoryRemoteDataSource;

  @override
  Future<Either<Failure, void>> delete(
      {required String walletId, required String category}) async {
    try {
      return Right(await categoryRemoteDataSource!
          .delete(walletId: walletId, category: category));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}

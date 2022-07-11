import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/change_password_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  ChangePasswordRepositoryImpl({required this.changePasswordRemoteDataSource});

  final ChangePasswordRemoteDataSource? changePasswordRemoteDataSource;
  @override
  Future<Either<Failure, void>> changePassword(
      {String? accessToken, String? newPassword, String? oldPassword}) async {
    try {
      return Right(await changePasswordRemoteDataSource!.changePassword(
          accessToken: accessToken,
          newPassword: newPassword,
          oldPassword: oldPassword));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }
}

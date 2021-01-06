import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';

abstract class UserAttributesRepository {
  Future<Either<Failure, User>> readUserAttributes();

  Future<void> writeUserAttributes(UserResponse userResponse);
}

import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

import '../use_case.dart';

class UpdateUserAttributes extends UseCase {
  UpdateUserAttributes({required this.userAttributesRepository});

  final UserAttributesRepository? userAttributesRepository;

  Future<Either<Failure, void>> updateUserAttributes(User user) async {
    return userAttributesRepository!.updateUserAttributes(user);
  }
}

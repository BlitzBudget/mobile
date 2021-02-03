import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

import '../use_case.dart';

class UpdateUserAttributes extends UseCase {
  final UserAttributesRepository userAttributesRepository;

  UpdateUserAttributes({@required this.userAttributesRepository});

  Future<Either<Failure, void>> updateUserAttributes(User user) async {
    return await userAttributesRepository.updateUserAttributes(user);
  }
}

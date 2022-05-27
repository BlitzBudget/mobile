import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class ForgotPassword extends UseCase {
  ForgotPassword({required this.authenticationRepository});

  final AuthenticationRepository? authenticationRepository;

  Future<Either<Failure, void>> forgotPassword({required String? email}) async {
    return authenticationRepository!.forgotPassword(email: email);
  }
}

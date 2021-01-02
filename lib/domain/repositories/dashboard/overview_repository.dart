import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

abstract class OverviewRepository {
  Future<Either<Failure, void>> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);
}

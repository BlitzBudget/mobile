import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';

abstract class OverviewRepository {
  Future<Either<Failure, OverviewResponse>> get(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId);
}

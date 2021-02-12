import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';

mixin OverviewRepository {
  Future<Either<Failure, OverviewResponse>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId});
}

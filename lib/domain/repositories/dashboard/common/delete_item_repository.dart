import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

mixin DeleteItemRepository {
  Future<Either<Failure, void>> delete(
      {required String walletID, required String itemID});
}

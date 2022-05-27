import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';

import '../../use_case.dart';

class ClearAllStorageUseCase extends UseCase {
  ClearAllStorageUseCase({required this.clearAllStorageRepository});

  late final ClearAllStorageRepository clearAllStorageRepository;

  Future<Either<Failure, void>> delete() async {
    return clearAllStorageRepository.clearAllStorage();
  }
}

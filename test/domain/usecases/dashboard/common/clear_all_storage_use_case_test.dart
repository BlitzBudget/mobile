import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/common/clear_all_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockClearAllStorageRepository extends Mock
    implements ClearAllStorageRepository {}

void main() {
  late ClearAllStorageUseCase clearAllStorageUseCase;
  late MockClearAllStorageRepository mockClearAllStorageRepository;

  setUp(() {
    mockClearAllStorageRepository = MockClearAllStorageRepository();
    clearAllStorageUseCase = ClearAllStorageUseCase(
        clearAllStorageRepository: mockClearAllStorageRepository);
  });

  group('Clear all storage use case', () {
    test('Success', () async {
      const clearAllStorageResponse = Right<Failure, void>('');
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value(clearAllStorageResponse));

      final response = await clearAllStorageUseCase.delete();
      expect(response.isRight(), true);
      verify(() => mockClearAllStorageRepository.clearAllStorage());
    });

    test('Failure', () async {
      final clearAllStorageResponse =
          Left<Failure, void>(EmptyResponseFailure());
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value(clearAllStorageResponse));

      final response = await clearAllStorageUseCase.delete();
      expect(response.isLeft(), true);
      verify(() => mockClearAllStorageRepository.clearAllStorage());
    });
  });
}

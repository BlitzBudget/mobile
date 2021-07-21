import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/ends_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/ends_with_date_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockEndsWithDateLocalDataSourceImpl extends Mock
    implements EndsWithDateLocalDataSourceImpl {}

void main() {
  MockEndsWithDateLocalDataSourceImpl? mockEndsWithDateLocalDataSourceImpl;
  EndsWithDateRepositoryImpl? endsWithDateRepositoryImpl;

  setUp(() {
    mockEndsWithDateLocalDataSourceImpl = MockEndsWithDateLocalDataSourceImpl();
    endsWithDateRepositoryImpl = EndsWithDateRepositoryImpl(
        endsWithDateLocalDataSource: mockEndsWithDateLocalDataSourceImpl);
  });
  test(
    'Should be a subclass of EndsWithDate entity',
    () async {
      // assert
      expect(endsWithDateRepositoryImpl, isA<EndsWithDateRepository>());
    },
  );

  group('Read Default Wallet', () {
    test('Throw a Failure when no value is found', () async {
      when(() => mockEndsWithDateLocalDataSourceImpl!.readEndsWithDate())
          .thenThrow(NoValueInCacheException());
      when(() => mockEndsWithDateLocalDataSourceImpl!.writeEndsWithDate(any()))
          .thenAnswer((_) => Future.value());
      await endsWithDateRepositoryImpl!.readEndsWithDate();
      verify(() => mockEndsWithDateLocalDataSourceImpl!.readEndsWithDate());
      verify(
          () => mockEndsWithDateLocalDataSourceImpl!.writeEndsWithDate(any()));
    });
  });
}

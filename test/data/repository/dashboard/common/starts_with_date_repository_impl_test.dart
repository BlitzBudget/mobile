import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/starts_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/starts_with_date_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mockito/mockito.dart';

class MockStartsWithDateLocalDataSourceImpl extends Mock
    implements StartsWithDateLocalDataSourceImpl {}

void main() {
  MockStartsWithDateLocalDataSourceImpl mockStartsWithDateLocalDataSourceImpl;
  StartsWithDateRepositoryImpl startsWithDateRepositoryImpl;

  setUp(() {
    mockStartsWithDateLocalDataSourceImpl =
        MockStartsWithDateLocalDataSourceImpl();
    startsWithDateRepositoryImpl = StartsWithDateRepositoryImpl(
        startsWithDateLocalDataSource: mockStartsWithDateLocalDataSourceImpl);
  });
  test(
    'Should be a subclass of StartsWithDate entity',
    () async {
      // assert
      expect(startsWithDateRepositoryImpl, isA<StartsWithDateRepository>());
    },
  );

  group('Read Starts With Date', () {
    test('Throw a Failure when no value is found', () async {
      when(mockStartsWithDateLocalDataSourceImpl.readStartsWithDate())
          .thenThrow(NoValueInCacheException());
      await startsWithDateRepositoryImpl.readStartsWithDate();
      verify(mockStartsWithDateLocalDataSourceImpl.readStartsWithDate());
      verify(mockStartsWithDateLocalDataSourceImpl.writeStartsWithDate(any));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/overview_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/overview_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockOverviewRemoteDataSource extends Mock
    implements OverviewRemoteDataSource {}

void main() {
  MockOverviewRemoteDataSource? mockOverviewRemoteDataSource;
  OverviewRepositoryImpl? overviewRepositoryImpl;

  setUp(() {
    mockOverviewRemoteDataSource = MockOverviewRemoteDataSource();
    overviewRepositoryImpl = OverviewRepositoryImpl(
        overviewRemoteDataSource: mockOverviewRemoteDataSource);
  });
  test(
    'Should be a subclass of OverviewRepository entity',
    () async {
      // assert
      expect(overviewRepositoryImpl, isA<OverviewRepository>());
    },
  );

  group('Fetch Overviews', () {
    test('Should return FetchDataFailure ', () async {
      when(() => mockOverviewRemoteDataSource!.fetch(
          defaultWallet: '',
          endsWithDate: '',
          startsWithDate: '',
          userId: '')).thenThrow(EmptyAuthorizationTokenException());
      final overviewReceived = await overviewRepositoryImpl!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: '');

      /// Expect an exception to be thrown
      final f =
          overviewReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockOverviewRemoteDataSource!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: ''));
      expect(overviewReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}

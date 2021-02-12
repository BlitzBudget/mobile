import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/category_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/category_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/category_repository.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

void main() {
  MockCategoryRemoteDataSource mockCategoryRemoteDataSource;
  CategoryRepositoryImpl categoryRepositoryImpl;

  setUp(() {
    mockCategoryRemoteDataSource = MockCategoryRemoteDataSource();
    categoryRepositoryImpl = CategoryRepositoryImpl(
        categoryRemoteDataSource: mockCategoryRemoteDataSource);
  });
  test(
    'Should be a subclass of CategoryRepository entity',
    () async {
      // assert
      expect(categoryRepositoryImpl, isA<CategoryRepository>());
    },
  );

  group('Delete Categorys', () {
    test('Should return FetchDataFailure ', () async {
      when(mockCategoryRemoteDataSource.delete(category: '', walletId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      final categoryReceived =
          await categoryRepositoryImpl.delete(category: '', walletId: '');

      /// Expect an exception to be thrown
      final f = categoryReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockCategoryRemoteDataSource.delete(category: '', walletId: ''));
      expect(categoryReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}

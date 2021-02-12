import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/common/delete_item_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/delete_item_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mockito/mockito.dart';

class MockDeleteItemRemoteDataSource extends Mock
    implements DeleteItemRemoteDataSource {}

void main() {
  MockDeleteItemRemoteDataSource mockDeleteItemRemoteDataSource;
  DeleteItemRepositoryImpl deleteItemRepositoryImpl;

  setUp(() {
    mockDeleteItemRemoteDataSource = MockDeleteItemRemoteDataSource();
    deleteItemRepositoryImpl = DeleteItemRepositoryImpl(
        deleteItemRemoteDataSource: mockDeleteItemRemoteDataSource);
  });
  test(
    'Should be a subclass of DeleteItemRepository entity',
    () async {
      // assert
      expect(deleteItemRepositoryImpl, isA<DeleteItemRepository>());
    },
  );

  group('Delete Item', () {
    test('Should return FetchDataFailure ', () async {
      when(mockDeleteItemRemoteDataSource.delete(itemId: '', walletId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      final deleteItemReceived =
          await deleteItemRepositoryImpl.delete(itemId: '', walletId: '');

      /// Expect an exception to be thrown
      final f =
          deleteItemReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockDeleteItemRemoteDataSource.delete(itemId: '', walletId: ''));
      expect(deleteItemReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}

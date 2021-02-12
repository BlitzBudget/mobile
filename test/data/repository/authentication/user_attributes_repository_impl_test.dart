import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/user_attributes_local_data_source.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/user_attributes_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mockito/mockito.dart';

class MockUserAttributesLocalDataSource extends Mock
    implements UserAttributesLocalDataSource {}

class MockUserAttributesRemoteDataSource extends Mock
    implements UserAttributesRemoteDataSource {}

void main() {
  MockUserAttributesLocalDataSource mockUserAttributesLocalDataSource;
  MockUserAttributesRemoteDataSource mockUserAttributesRemoteDataSource;
  UserAttributesRepositoryImpl userAttributesRepositoryImpl;

  setUp(() {
    mockUserAttributesRemoteDataSource = MockUserAttributesRemoteDataSource();
    mockUserAttributesLocalDataSource = MockUserAttributesLocalDataSource();
    userAttributesRepositoryImpl = UserAttributesRepositoryImpl(
        userAttributesLocalDataSource: mockUserAttributesLocalDataSource,
        userAttributesRemoteDataSource: mockUserAttributesRemoteDataSource);
  });
  test(
    'Should be a subclass of UserAttributesRepository entity',
    () async {
      // assert
      expect(userAttributesRepositoryImpl, isA<UserAttributesRepository>());
    },
  );

  group('Read Auth Token', () {
    test('Should return Empty Response Failure', () async {
      when(mockUserAttributesLocalDataSource.readUserAttributes())
          .thenThrow(NoValueInCacheException());
      final userAttributesReceived =
          await userAttributesRepositoryImpl.readUserAttributes();

      /// Expect an exception to be thrown
      final f = userAttributesReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      expect(userAttributesReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });

  group('Update User Attributes', () {
    test('Should return Fetch Data Failure', () async {
      const userModel = UserModel();
      when(mockUserAttributesRemoteDataSource.updateUserAttributes(userModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final userAttributesReceived =
          await userAttributesRepositoryImpl.updateUserAttributes(userModel);

      /// Expect an exception to be thrown
      final f = userAttributesReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      verify(
          mockUserAttributesRemoteDataSource.updateUserAttributes(userModel));
      expect(userAttributesReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}

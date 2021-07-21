import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/change_password_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/change_password_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/change_password_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordRemoteDataSource extends Mock
    implements ChangePasswordRemoteDataSource {}

void main() {
  MockChangePasswordRemoteDataSource? mockChangePasswordRemoteDataSource;
  ChangePasswordRepositoryImpl? changePasswordRepositoryImpl;

  setUp(() {
    mockChangePasswordRemoteDataSource = MockChangePasswordRemoteDataSource();
    changePasswordRepositoryImpl = ChangePasswordRepositoryImpl(
        changePasswordRemoteDataSource: mockChangePasswordRemoteDataSource);
  });
  test(
    'Should be a subclass of ChangePasswordRepository entity',
    () async {
      // assert
      expect(changePasswordRepositoryImpl, isA<ChangePasswordRepository>());
    },
  );

  group('Change Password', () {
    test('Should return Fetch Data Failure', () async {
      when(() => mockChangePasswordRemoteDataSource!.changePassword(
          accessToken: '',
          oldPassword: '',
          newPassword: '')).thenThrow(EmptyAuthorizationTokenException());
      final changePasswordReceived = await changePasswordRepositoryImpl!
          .changePassword(accessToken: '', oldPassword: '', newPassword: '');

      /// Expect an exception to be thrown
      final f = changePasswordReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      verify(() => mockChangePasswordRemoteDataSource!
          .changePassword(accessToken: '', oldPassword: '', newPassword: ''));
      expect(changePasswordReceived.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });
}

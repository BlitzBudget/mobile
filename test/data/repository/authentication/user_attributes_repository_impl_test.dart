import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/user_attributes_local_data_source.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/user_attributes_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockUserAttributesLocalDataSource extends Mock
    implements UserAttributesLocalDataSource {}

class MockUserAttributesRemoteDataSource extends Mock
    implements UserAttributesRemoteDataSource {}

void main() {
  MockUserAttributesLocalDataSource? mockUserAttributesLocalDataSource;
  MockUserAttributesRemoteDataSource? mockUserAttributesRemoteDataSource;
  UserAttributesRepositoryImpl? userAttributesRepositoryImpl;

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

  group('Read User Attributes', () {
    final loginResponseAsString =
        fixture('responses/authentication/login_info.json');
    final userAttributesAsMap =
        jsonDecode(loginResponseAsString)['UserAttributes'];
    final userAttributeAsString = jsonEncode(userAttributesAsMap);
    const email = 'nagarjun_nagesh@outlook.com';
    const familyName = ' ';
    const fileFormat = 'XLS';
    const locale = 'en-US';
    const name = 'nagarjun_nagesh';
    const userId = 'User#2020-12-21T20:32:06.003Z';
    const userAttributes = UserModel(
        email: email,
        familyName: familyName,
        fileFormat: fileFormat,
        locale: locale,
        name: name,
        userId: userId);

    test('Should return Empty Response Failure', () async {
      when(() => mockUserAttributesLocalDataSource!.readUserAttributes())
          .thenThrow(NoValueInCacheException());
      final userAttributesReceived =
          await userAttributesRepositoryImpl!.readUserAttributes();

      /// Expect an exception to be thrown
      final f = userAttributesReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      expect(userAttributesReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
      verify(() => mockUserAttributesLocalDataSource!.readUserAttributes());
    });

    test('Should return Valid Response', () async {
      when(() => mockUserAttributesLocalDataSource!.readUserAttributes())
          .thenAnswer((_) => Future.value(userAttributeAsString));
      final userAttributesReceived =
          await userAttributesRepositoryImpl!.readUserAttributes();

      /// Expect an exception to be thrown
      expect(userAttributesReceived.isRight(), equals(true));
      expect(
          userAttributesReceived.getOrElse(() => null), equals(userAttributes));
      verify(() => mockUserAttributesLocalDataSource!.readUserAttributes());
    });
  });

  group('Update User Attributes', () {
    test('Should return Success', () async {
      const userModel = UserModel();
      when(() => mockUserAttributesRemoteDataSource!
              .updateUserAttributes(userModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final userAttributesReceived =
          await userAttributesRepositoryImpl!.updateUserAttributes(userModel);

      /// Expect an exception to be thrown
      final f = userAttributesReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      verify(() =>
          mockUserAttributesRemoteDataSource!.updateUserAttributes(userModel));
      expect(userAttributesReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });

    test('Should return Fetch Data Failure', () async {
      const userModel = UserModel();
      when(() => mockUserAttributesRemoteDataSource!
          .updateUserAttributes(userModel)).thenAnswer((_) => Future.value());

      final userAttributesReceived =
          await userAttributesRepositoryImpl!.updateUserAttributes(userModel);

      /// Expect an exception to be thrown
      verify(() =>
          mockUserAttributesRemoteDataSource!.updateUserAttributes(userModel));
      expect(userAttributesReceived.isRight(), equals(true));
    });
  });

  group('Write User Attributes', () {
    final userModelAsString =
        fixture('responses/authentication/login_info.json');
    final userModelAsJSON = jsonDecode(userModelAsString);
    final userResponse = UserResponse(
        accessToken: userModelAsJSON['AuthenticationResult']['AccessToken'],
        authenticationToken: userModelAsJSON['AuthenticationResult']['IdToken'],
        refreshToken: userModelAsJSON['AuthenticationResult']['RefreshToken'],
        user: UserModel.fromJSON(userModelAsJSON['UserAttributes']),
        wallet: WalletModel.fromJSON(userModelAsJSON['Wallet'][0]));
    final encodedUser = userResponse.user as UserModel;
    final encodedUserString = jsonEncode(encodedUser.toJSON());

    test('Should write user attributes', () async {
      when(() => mockUserAttributesLocalDataSource!
              .writeUserAttributes(encodedUserString))
          .thenAnswer((_) => Future.value());
      await userAttributesRepositoryImpl!.writeUserAttributes(userResponse);
      verify(() => mockUserAttributesLocalDataSource!
          .writeUserAttributes(encodedUserString));
    });
  });
}

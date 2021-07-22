import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/update_user_attributes.dart';
import 'package:mocktail/mocktail.dart';

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  MockUserAttributesRepository? mockUserAttributesRepository;
  late UpdateUserAttributes updateUserAttributes;
  const user = User(
      userId: 'User#2020-12-21T20:32:06.003Z',
      email: 'nagarjun_nagesh@outlook.com',
      locale: 'en-US',
      name: 'Nagarjun',
      familyName: 'Nagesh',
      fileFormat: 'XLS');

  setUp(() {
    mockUserAttributesRepository = MockUserAttributesRepository();
    updateUserAttributes = UpdateUserAttributes(
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Success: UpdateUserAttributes', () {
    test('Should receive a successful response', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(() => mockUserAttributesRepository!.updateUserAttributes(user))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final userAttributeResponse =
          await updateUserAttributes.updateUserAttributes(user);
      expect(userAttributeResponse.isRight(), true);
      verify(() => mockUserAttributesRepository!.updateUserAttributes(user));
    });
  });

  group('ERROR: UpdateUserAttributes', () {
    test('Should receive a failure response', () async {
      final eitherUserResponseMonad = Left<Failure, void>(FetchDataFailure());
      when(() => mockUserAttributesRepository!.updateUserAttributes(user))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final updateUserAttributeResponse =
          await updateUserAttributes.updateUserAttributes(user);
      expect(updateUserAttributeResponse.isLeft(), equals(true));
      verify(() => mockUserAttributesRepository!.updateUserAttributes(user));
    });
  });
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final addUserAsString = fixture('models/add/authentication/user.json');
  final addUserAsJSON = jsonDecode(addUserAsString);
  const user = User(
      userId: 'User#2020-12-21T20:32:06.003Z',
      familyName: 'Nagesh',
      name: 'Nagarjun',
      locale: 'en-US',
      fileFormat: 'XLS',
      email: 'nagarjun_nagesh@outlook.com');
  test(
    'Should be a subclass of Equatable entity',
    () async {
      // assert
      expect(const User(), isA<Equatable>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final userModelConverted = User.fromJSON(user.toJSONForUser());
      expect(userModelConverted, equals(user));
    });
  });

  group('toJsonForUser', () {
    test('Should return a JSON map containing the proper data', () async {
      expect(user.toJSONForUser(), equals(addUserAsJSON));
    });
  });
}

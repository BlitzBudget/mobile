import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final userModelAsString =
      fixture('models/get/authentication/login_info.json');
  final userModelAsJSON = jsonDecode(userModelAsString);
  const userModel = UserModel(
      userId: 'User#2020-12-21T20:32:06.003Z',
      familyName: ' ',
      name: 'nagarjun_nagesh',
      locale: 'en-US',
      fileFormat: 'XLS',
      email: 'nagarjun_nagesh@outlook.com');
  test(
    'Should be a subclass of UserModel entity',
    () async {
      // assert
      expect(userModel, isA<User>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final userModelConverted = UserModel.fromJSON(userModelAsJSON);
      expect(userModelConverted, equals(userModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addUserModelAsString =
          fixture('models/add/authentication/user_model.json');
      final addUserModelAsJSON =
          jsonDecode(addUserModelAsString);
      expect(userModel.toJSON(), equals(addUserModelAsJSON));
    });
  });
}

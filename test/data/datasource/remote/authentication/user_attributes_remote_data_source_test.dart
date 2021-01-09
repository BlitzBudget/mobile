import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  UserAttributesRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource =
        UserAttributesRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to update user attrbutes', () {
    test(
      'Should update a user attributes name',
      () async {
        final updateUserNameAsString = fixture(
            'responses/user-attributes/update/user_attribute_name_info.json');
        final updateUserNameAsJSON =
            jsonDecode(updateUserNameAsString) as Map<String, dynamic>;
        final userAttributes = UserModel(
            email: updateUserNameAsJSON['body-json']['username'] as String,
            name: updateUserNameAsJSON['body-json']['name'] as String,
            familyName:
                updateUserNameAsJSON['body-json']['family_name'] as String);
        // arrange
        when(mockHTTPClientImpl.post(constants.userAttributesURL,
                body: jsonEncode(userAttributes.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateUserNameAsJSON);
        // act
        await dataSource.updateUserAttributes(userAttributes);
        // assert
        verify(mockHTTPClientImpl.post(constants.userAttributesURL,
            body: jsonEncode(userAttributes.toJSON()),
            headers: constants.headers));
      },
    );
  });
}

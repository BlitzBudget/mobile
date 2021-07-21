import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/change_password_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late ChangePasswordRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource =
        ChangePasswordRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to change old password', () {
    test(
      'Should change old password',
      () async {
        final changePasswordContent = {
          'accessToken':
              'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6Ijk0ZmE5MTFjLTUzZWQtNDIzYi1hMzdkLWExMDJjZDFlMjdiMyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MTAyNzU4NjMsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYxMDI3OTQ2MywiaWF0IjoxNjEwMjc1ODYzLCJqdGkiOiJlMzRjN2E4Zi1lZTU4LTRmNGMtYTI4ZS01ZmQwMTUxNGIxN2UiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.YLEqAFo1bcx81yXjjt38MdZWiYNaKrlAGJWIRsYUmpB7sFwClPzgxYHsJfn6w_FwignWjRj9cMsNerSjADO6O-wjUAhoCqtDrZjf_V6rk3Oyu15Cdi3e93wN81nOQzi2ftX9IaBl475f5p7StUmhO212EOi7PWFYa-H1lWsBSS3m65ervOY8sHXYvl4u5CSG0rq5CU9XU2kBmGbv5a67cJMsGIO8kI5B3Zt9fblBaUyKdv_vDvo2qzXnaTYFcSX_tTJkj32NVzq230MEppnqpltmMywv9rd8ORZVgO25-bYmO7-zXbphzbBDtdOafVuJdHycvQ1ZV0qNEh9BhFI6Dg',
          'newPassword': 'Minnu18.',
          'previousPassword': 'MInnu18.'
        };
        final contentBody = jsonEncode(changePasswordContent);
        // arrange
        when(() => mockHTTPClientImpl!.post(constants.changePasswordURL,
                body: contentBody, headers: constants.headers))
            .thenAnswer((_) async => <String, dynamic>{});
        // act
        await dataSource.changePassword(
            accessToken: changePasswordContent['accessToken'],
            oldPassword: changePasswordContent['previousPassword'],
            newPassword: changePasswordContent['newPassword']);
        // assert
        verify(() => mockHTTPClientImpl!.post(constants.changePasswordURL,
            body: contentBody, headers: constants.headers));
      },
    );
  });
}

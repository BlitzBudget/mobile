import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/clear_all_storage_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  MockSharedPreferences? mockSharedPreferences;
  MockFlutterSecureStorage? mockFlutterSecureStorage;
  ClearAllStorageRepositoryImpl? clearAllStorageRepositoryImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    clearAllStorageRepositoryImpl = ClearAllStorageRepositoryImpl(
        flutterSecureStorage: mockFlutterSecureStorage,
        sharedPreferences: mockSharedPreferences);
  });
  test(
    'Should be a subclass of ClearAllStorageRepository entity',
    () async {
      // assert
      expect(clearAllStorageRepositoryImpl, isA<ClearAllStorageRepository>());
    },
  );

  group('Clear All Storage', () {
    test('Should clear all storage', () async {
      when(() => mockSharedPreferences!.clear())
          .thenAnswer((_) => Future.value(true));
      when(() => mockFlutterSecureStorage!.deleteAll())
          .thenAnswer((_) => Future.value());
      await clearAllStorageRepositoryImpl!.clearAllStorage();
      verify(() => mockSharedPreferences!.clear());
      verify(() => mockFlutterSecureStorage!.deleteAll());
    });
  });
}

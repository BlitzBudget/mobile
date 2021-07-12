// This is our global ServiceLocator

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/refresh_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/authentication_repository_impl.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/user_attributes_repository_impl.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/clear_all_storage_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/forgot_password.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/http_client.dart';
import 'core/network/network_helper.dart';
import 'core/network/network_info.dart';
import 'core/network/refresh_token_helper.dart';
import 'core/persistence/secure_key_value_store.dart';
import 'data/datasource/local/authentication/access_token_local_data_source.dart';
import 'data/datasource/local/authentication/auth_token_local_data_source.dart';
import 'data/datasource/local/authentication/user_attributes_local_data_source.dart';
import 'data/datasource/remote/authentication/authentication_remote_data_source.dart';
import 'data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'data/repositories/authentication/access_token_repository_impl.dart';
import 'data/repositories/authentication/auth_token_repository_impl.dart';
import 'data/repositories/authentication/refresh_token_repository_impl.dart';
import 'domain/repositories/authentication/auth_token_repository.dart';
import 'domain/repositories/dashboard/common/clear_all_storage_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Use Case
  getIt.registerLazySingleton(() => LoginUser(
      authenticationRepository: getIt(),
      userAttributesRepository: getIt(),
      refreshTokenRepository: getIt(),
      accessTokenRepository: getIt(),
      authTokenRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => ForgotPassword(authenticationRepository: getIt()));

  // Repository
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(authenticationRemoteDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesRepository>(() =>
      UserAttributesRepositoryImpl(
          userAttributesLocalDataSource: getIt(),
          userAttributesRemoteDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<RefreshTokenRepository>(
      () => RefreshTokenRepositoryImpl(refreshTokenLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AccessTokenRepository>(
      () => AccessTokenRepositoryImpl(accessTokenLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AuthTokenRepository>(
      () => AuthTokenRepositoryImpl(authTokenLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<ClearAllStorageRepository>(() =>
      ClearAllStorageRepositoryImpl(
          sharedPreferences: getIt(), flutterSecureStorage: getIt()));

  // Datasource
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesLocalDataSource>(
      () => UserAttributesLocalDataSourceImpl(secureKeyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesRemoteDataSource>(
      () => UserAttributesRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<RefreshTokenLocalDataSource>(
      () => RefreshTokenLocalDataSourceImpl(secureKeyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AccessTokenLocalDataSource>(
      () => AccessTokenLocalDataSourceImpl(secureKeyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<AuthTokenLocalDataSource>(
      () => AuthTokenLocalDataSourceImpl(secureKeyValueStore: getIt()));

  // Core
  // ignore: cascade_invocations
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<HTTPClient>(() => HTTPClientImpl(
      authTokenRepository: getIt(),
      accessTokenRepository: getIt(),
      refreshTokenHelper: getIt(),
      networkHelper: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<NetworkHelper>(
      () => NetworkHelper(httpClient: getIt(), networkInfo: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<SecureKeyValueStore>(
      () => SecureKeyValueStoreImpl(flutterSecureStorage: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<RefreshTokenHelper>(() => RefreshTokenHelper(
      accessTokenRepository: getIt(),
      authTokenRepository: getIt(),
      clearAllStorageRepository: getIt(),
      httpClient: getIt(),
      networkHelper: getIt(),
      refreshTokenRepository: getIt()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => http.Client());
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DataConnectionChecker());
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
}

// This is our global ServiceLocator

import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import 'package:mobile_blitzbudget/domain/usecases/authentication/verify_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/http_client.dart';
import 'core/network/network_helper.dart';
import 'core/network/network_info.dart';
import 'core/network/refresh_token_helper.dart';
import 'core/persistence/secure_key_value_store.dart';
import 'data/datasource/local/authentication/access_token_local_data_source.dart';
import 'data/datasource/local/authentication/auth_token_local_data_source.dart';
import 'data/datasource/local/authentication/user_attributes_local_data_source.dart';
import 'data/datasource/local/dashboard/default_wallet_local_data_source.dart';
import 'data/datasource/local/dashboard/ends_with_date_local_data_source.dart';
import 'data/datasource/local/dashboard/starts_with_date_local_data_source.dart';
import 'data/datasource/remote/authentication/authentication_remote_data_source.dart';
import 'data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'data/datasource/remote/dashboard/common/delete_item_remote_data_source.dart';
import 'data/datasource/remote/dashboard/transaction/transaction_remote_data_source.dart';
import 'data/repositories/authentication/access_token_repository_impl.dart';
import 'data/repositories/authentication/auth_token_repository_impl.dart';
import 'data/repositories/authentication/refresh_token_repository_impl.dart';
import 'data/repositories/dashboard/common/default_wallet_repository_impl.dart';
import 'data/repositories/dashboard/common/delete_item_repository_impl.dart';
import 'data/repositories/dashboard/common/ends_with_date_repository_impl.dart';
import 'data/repositories/dashboard/common/starts_with_date_repository_impl.dart';
import 'data/repositories/dashboard/transaction/transaction_repository_impl.dart';
import 'domain/repositories/authentication/auth_token_repository.dart';
import 'domain/repositories/dashboard/common/clear_all_storage_repository.dart';
import 'domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'domain/repositories/dashboard/common/delete_item_repository.dart';
import 'domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'domain/usecases/authentication/signup_user.dart';
import 'domain/usecases/dashboard/transaction/add_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/delete_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/fetch_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/update_transaction_use_case.dart';

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
      () => SignupUser(authenticationRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => ForgotPassword(authenticationRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => VerifyUser(authenticationRepository: getIt()));

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
  getIt.registerLazySingleton(() => InternetConnectionChecker());
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Dashboard

  // Transactions

  // Use case
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => UpdateTransactionUseCase(
      transactionRepository: getIt(), defaultWalletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => AddTransactionUseCase(transactionRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteTransactionUseCase(
      defaultWalletRepository: getIt(), deleteItemRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => FetchTransactionUseCase(
      defaultWalletRepository: getIt(),
      endsWithDateRepository: getIt(),
      startsWithDateRepository: getIt(),
      transactionRepository: getIt(),
      userAttributesRepository: getIt()));

  // Repository
  // ignore: cascade_invocations
  getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(transactionRemoteDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<DefaultWalletRepository>(
      () => DefaultWalletRepositoryImpl(defaultWalletLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<DeleteItemRepository>(
      () => DeleteItemRepositoryImpl(deleteItemRemoteDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<EndsWithDateRepository>(
      () => EndsWithDateRepositoryImpl(endsWithDateLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<StartsWithDateRepository>(() =>
      StartsWithDateRepositoryImpl(startsWithDateLocalDataSource: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesRepository>(() =>
      UserAttributesRepositoryImpl(
          userAttributesLocalDataSource: getIt(),
          userAttributesRemoteDataSource: getIt()));

  // Data Source
  // ignore: cascade_invocations
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<DefaultWalletLocalDataSource>(
      () => DefaultWalletLocalDataSourceImpl(keyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<DeleteItemRemoteDataSource>(
      () => DeleteItemRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<EndsWithDateLocalDataSource>(
      () => EndsWithDateLocalDataSourceImpl(keyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<StartsWithDateLocalDataSource>(
      () => StartsWithDateLocalDataSourceImpl(keyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesLocalDataSource>(
      () => UserAttributesLocalDataSourceImpl(secureKeyValueStore: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<UserAttributesRemoteDataSource>(
      () => UserAttributesRemoteDataSourceImpl(httpClient: getIt()));
}

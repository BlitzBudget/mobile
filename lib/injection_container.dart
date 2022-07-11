// This is our global ServiceLocator

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store_impl.dart';
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
import 'data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'data/datasource/remote/dashboard/category_remote_data_source.dart';
import 'data/datasource/remote/dashboard/common/delete_item_remote_data_source.dart';
import 'data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'data/datasource/remote/dashboard/transaction/recurring_transaction_remote_data_source.dart';
import 'data/datasource/remote/dashboard/transaction/transaction_remote_data_source.dart';
import 'data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'data/repositories/authentication/access_token_repository_impl.dart';
import 'data/repositories/authentication/auth_token_repository_impl.dart';
import 'data/repositories/authentication/refresh_token_repository_impl.dart';
import 'data/repositories/dashboard/bank_account_repository_impl.dart';
import 'data/repositories/dashboard/budget_repository_impl.dart';
import 'data/repositories/dashboard/category_repository_impl.dart';
import 'data/repositories/dashboard/common/default_wallet_repository_impl.dart';
import 'data/repositories/dashboard/common/delete_item_repository_impl.dart';
import 'data/repositories/dashboard/common/ends_with_date_repository_impl.dart';
import 'data/repositories/dashboard/common/starts_with_date_repository_impl.dart';
import 'data/repositories/dashboard/goal_repository_impl.dart';
import 'data/repositories/dashboard/overview_repository_impl.dart';
import 'data/repositories/dashboard/transaction/recurring_transaction_repository_impl.dart';
import 'data/repositories/dashboard/transaction/transaction_repository_impl.dart';
import 'data/repositories/dashboard/wallet_repository_impl.dart';
import 'domain/repositories/authentication/auth_token_repository.dart';
import 'domain/repositories/dashboard/bank_account_repository.dart';
import 'domain/repositories/dashboard/budget_repository.dart';
import 'domain/repositories/dashboard/category_repository.dart';
import 'domain/repositories/dashboard/common/clear_all_storage_repository.dart';
import 'domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'domain/repositories/dashboard/common/delete_item_repository.dart';
import 'domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'domain/repositories/dashboard/goal_repository.dart';
import 'domain/repositories/dashboard/overview_repository.dart';
import 'domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';
import 'domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'domain/repositories/dashboard/wallet_repository.dart';
import 'domain/usecases/authentication/signup_user.dart';
import 'domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart';
import 'domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart';
import 'domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart';
import 'domain/usecases/dashboard/budget/add_budget_use_case.dart';
import 'domain/usecases/dashboard/budget/delete_budget_use_case.dart';
import 'domain/usecases/dashboard/budget/fetch_budget_use_case.dart';
import 'domain/usecases/dashboard/budget/update_budget_use_case.dart';
import 'domain/usecases/dashboard/category/delete_category_use_case.dart';
import 'domain/usecases/dashboard/goal/add_goal_use_case.dart';
import 'domain/usecases/dashboard/goal/delete_goal_use_case.dart';
import 'domain/usecases/dashboard/goal/fetch_goal_use_case.dart';
import 'domain/usecases/dashboard/goal/update_goal_use_case.dart';
import 'domain/usecases/dashboard/overview/fetch_overview_use_case.dart';
import 'domain/usecases/dashboard/recurring-transaction/delete_recurring_transaction_use_case.dart';
import 'domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/add_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/delete_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/fetch_transaction_use_case.dart';
import 'domain/usecases/dashboard/transaction/update_transaction_use_case.dart';
import 'domain/usecases/dashboard/wallet/add_wallet_use_case.dart';
import 'domain/usecases/dashboard/wallet/delete_wallet_use_case.dart';
import 'domain/usecases/dashboard/wallet/fetch_wallet_use_case.dart';
import 'domain/usecases/dashboard/wallet/update_wallet_use_case.dart';

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
  // ignore: cascade_invocations
  getIt.registerLazySingleton<KeyValueStore>(
      () => KeyValueStoreImpl(sharedPreferences: sharedPreferences));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<SecureKeyValueStore>(
      () => SecureKeyValueStoreImpl(flutterSecureStorage: getIt()));

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

  // Wallet

  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => FetchWalletUseCase(
      defaultWalletRepository: getIt(),
      endsWithDateRepository: getIt(),
      startsWithDateRepository: getIt(),
      userAttributesRepository: getIt(),
      walletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => UpdateWalletUseCase(walletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => AddWalletUseCase(
      userAttributesRepository: getIt(), walletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteWalletUseCase(
      userAttributesRepository: getIt(), walletRepository: getIt()));

  // Recurring Transaction

  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => UpdateRecurringTransactionUseCase(
      defaultWalletRepository: getIt(),
      recurringTransactionRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteRecurringTransactionUseCase(
      defaultWalletRepository: getIt(), deleteItemRepository: getIt()));

  // Overview
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => FetchOverviewUseCase(
      defaultWalletRepository: getIt(),
      endsWithDateRepository: getIt(),
      overviewRepository: getIt(),
      startsWithDateRepository: getIt(),
      userAttributesRepository: getIt()));

  // Goal
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteGoalUseCase(
      defaultWalletRepository: getIt(), deleteItemRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => AddGoalUseCase(goalRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => FetchGoalUseCase(
      defaultWalletRepository: getIt(),
      endsWithDateRepository: getIt(),
      goalRepository: getIt(),
      startsWithDateRepository: getIt(),
      userAttributesRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => UpdateGoalUseCase(goalRepository: getIt()));

  // Category
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteCategoryUseCase(
      categoryRepository: getIt(), defaultWalletRepository: getIt()));

  // Budget
  // ignore: cascade_invocations
  getIt
      .registerLazySingleton(() => AddBudgetUseCase(budgetRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => UpdateBudgetUseCase(
      budgetRepository: getIt(), defaultWalletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteBudgetUseCase(
      defaultWalletRepository: getIt(), deleteItemRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => FetchBudgetUseCase(
      budgetRepository: getIt(),
      defaultWalletRepository: getIt(),
      endsWithDateRepository: getIt(),
      startsWithDateRepository: getIt(),
      userAttributesRepository: getIt()));

  // Bank Account
  // ignore: cascade_invocations
  getIt.registerLazySingleton(
      () => AddBankAccountUseCase(bankAccountRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => UpdateBankAccountUseCase(
      bankAccountRepository: getIt(), defaultWalletRepository: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton(() => DeleteBankAccountUseCase(
      bankAccountRepository: getIt(), defaultWalletRepository: getIt()));

  /// Repository

  // Overview
  // ignore: cascade_invocations
  getIt.registerLazySingleton<OverviewRepository>(
      () => OverviewRepositoryImpl(overviewRemoteDataSource: getIt()));

  // Bank Account
  // ignore: cascade_invocations
  getIt.registerLazySingleton<BankAccountRepository>(
      () => BankAccountRepositoryImpl(bankAccountRemoteDataSource: getIt()));

  // Budget
  // ignore: cascade_invocations
  getIt.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(budgetRemoteDataSource: getIt()));

  // Category
  // ignore: cascade_invocations
  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(categoryRemoteDataSource: getIt()));

  // Goal
  // ignore: cascade_invocations
  getIt.registerLazySingleton<GoalRepository>(
      () => GoalRepositoryImpl(goalRemoteDataSource: getIt()));

  // Recurring Transaction
  // ignore: cascade_invocations
  getIt.registerLazySingleton<RecurringTransactionRepository>(() =>
      RecurringTransactionRepositoryImpl(
          recurringTransactionRemoteDataSource: getIt()));

  // Wallet

  // ignore: cascade_invocations
  getIt.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(walletRemoteDataSource: getIt()));

  // Transaction

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

  /// Data Source

  // ignore: cascade_invocations
  getIt.registerLazySingleton<OverviewRemoteDataSource>(
      () => OverviewRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<BankAccountRemoteDataSource>(
      () => BankAccountRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<BudgetRemoteDataSource>(
      () => BudgetRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<RecurringTransactionRemoteDataSource>(
      () => RecurringTransactionRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(httpClient: getIt()));
  // ignore: cascade_invocations
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(httpClient: getIt()));
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
  // ignore: cascade_invocations
  getIt.registerLazySingleton<DefaultWalletLocalDataSource>(
      () => DefaultWalletLocalDataSourceImpl(keyValueStore: getIt()));
}

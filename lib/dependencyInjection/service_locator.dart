import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/repositories/expense_category_repository_impl.dart';
import '../domain/repositories/expense_category_repository.dart';
import '../presentation/blocs/expense_category_cubit.dart';
import '../presentation/blocs/navigation_cubit.dart';
import '../presentation/blocs/budget_cubit.dart';
import '../presentation/blocs/expense_cubit.dart';
import '../presentation/blocs/add_expense_form_cubit.dart';
import '../presentation/blocs/recommended_cubit.dart';
import '../presentation/blocs/add_expense_category_cubit.dart';
import '../core/router/app_router.dart';
import '../services/hive_storage_service.dart';
import '../data/models/budget.dart';
import '../data/models/expense.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register Hive adapters
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  // Register HiveStorageService
  getIt.registerLazySingleton<HiveStorageService>(() => HiveStorageService());

  // Initialize Hive storage
  await getIt<HiveStorageService>().initialize();

  // Register Dio instance
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'https://media.halogen.my/experiment/mobile/';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  // Register repositories
  getIt.registerLazySingleton<ExpenseCategoryRepository>(
      () => ExpenseCategoryRepositoryImpl(getIt<Dio>()));

  // Register Cubits
  getIt.registerFactory<ExpenseCategoryCubit>(() => ExpenseCategoryCubit(
      getIt<ExpenseCategoryRepository>(), getIt<HiveStorageService>()));
  getIt.registerFactory<NavigationCubit>(() => NavigationCubit());
  getIt.registerFactory<BudgetCubit>(
      () => BudgetCubit(getIt<HiveStorageService>()));
  getIt.registerFactory<ExpenseCubit>(
      () => ExpenseCubit(getIt<HiveStorageService>()));
  getIt.registerFactory<AddExpenseFormCubit>(() => AddExpenseFormCubit());
  getIt.registerFactory<RecommendedCubit>(() => RecommendedCubit(
      getIt<ExpenseCategoryRepository>(), getIt<HiveStorageService>()));
  getIt.registerFactory<AddExpenseCategoryCubit>(() => AddExpenseCategoryCubit(
      getIt<ExpenseCategoryRepository>(), getIt<HiveStorageService>()));

  // Register Router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/category/category_bloc.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/category/delete_category_use_case.dart'
    as delete_category_usecase;
import 'package:mobile_blitzbudget/app/ploc/dashboard/category/category_constants.dart'
    as constants;

class MockDeleteCategoryUseCase extends Mock
    implements delete_category_usecase.DeleteCategoryUseCase {}

void main() {
  late MockDeleteCategoryUseCase mockDeleteCategoryUseCase;
  const CATEGORY_ID = 'categoryId';
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    mockDeleteCategoryUseCase = MockDeleteCategoryUseCase();
  });

  group('Success: CategoryBloc', () {
    blocTest<CategoryBloc, CategoryState>(
      'Emits [Success] states for delete bank account success',
      build: () {
        when(() => mockDeleteCategoryUseCase.delete(itemId: CATEGORY_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return CategoryBloc(deleteCategoryUseCase: mockDeleteCategoryUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: CATEGORY_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error: Fetch Data Failure CategoryBloc', () {
    blocTest<CategoryBloc, CategoryState>(
      'Emits [Success] states for delete bank account success',
      build: () {
        final failureResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteCategoryUseCase.delete(itemId: CATEGORY_ID))
            .thenAnswer((_) => Future.value(failureResponse));
        return CategoryBloc(deleteCategoryUseCase: mockDeleteCategoryUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: CATEGORY_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });

  group('Error: Generic API Failure CategoryBloc', () {
    blocTest<CategoryBloc, CategoryState>(
      'Emits [Success] states for delete bank account success',
      build: () {
        final failureResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteCategoryUseCase.delete(itemId: CATEGORY_ID))
            .thenAnswer((_) => Future.value(failureResponse));
        return CategoryBloc(deleteCategoryUseCase: mockDeleteCategoryUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: CATEGORY_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });
}

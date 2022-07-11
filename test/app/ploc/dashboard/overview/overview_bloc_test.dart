import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/overview/overview_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/overview/overview_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/overview/fetch_overview_use_case.dart'
    as fetch_overview_usecase;
import 'package:mocktail/mocktail.dart';

class MockOverviewUseCase extends Mock
    implements fetch_overview_usecase.FetchOverviewUseCase {}

void main() {
  late MockOverviewUseCase mockOverviewUseCase;

  setUp(() {
    mockOverviewUseCase = MockOverviewUseCase();
  });

  group('Success: OverviewBloc', () {
    blocTest<OverviewBloc, OverviewState>(
      'Emits [Success] states for overview success',
      build: () {
        const positiveMonadResponse =
            Right<Failure, OverviewResponse>(OverviewResponse());
        when(() => mockOverviewUseCase.fetch())
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return OverviewBloc(fetchOverviewUseCase: mockOverviewUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error: Fetch Data Failure OverviewBloc', () {
    blocTest<OverviewBloc, OverviewState>(
      'Emits [FetchDataFailure] states for overview error',
      build: () {
        final failureMonadResponse =
            Left<Failure, OverviewResponse>(FetchDataFailure());
        when(() => mockOverviewUseCase.fetch())
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return OverviewBloc(fetchOverviewUseCase: mockOverviewUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });

  group('Error: Generic API Failure OverviewBloc', () {
    blocTest<OverviewBloc, OverviewState>(
      'Emits [GenericAPIFailure] states for overview error',
      build: () {
        final failureMonadResponse =
            Left<Failure, OverviewResponse>(GenericAPIFailure());
        when(() => mockOverviewUseCase.fetch())
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return OverviewBloc(fetchOverviewUseCase: mockOverviewUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });
}

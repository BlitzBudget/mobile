import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../../domain/usecases/dashboard/overview/fetch_overview_use_case.dart'
    as fetch_overview_usecase;
import 'overview_constants.dart' as constants;

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc({required this.fetchOverviewUseCase}) : super(Empty());

  final fetch_overview_usecase.FetchOverviewUseCase fetchOverviewUseCase;

  Stream<OverviewState> mapEventToState(
    OverviewEvent event,
  ) async* {
    yield Loading();

    if (event is Fetch) {
      final fetchResponse = await fetchOverviewUseCase.fetch();
      yield fetchResponse.fold(_convertToMessage, _successResponse);
    }
  }

  OverviewState _successResponse(void r) {
    return Success();
  }

  OverviewState _convertToMessage(Failure failure) {
    debugPrint('Converting overview failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

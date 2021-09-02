import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import '../../../../domain/usecases/dashboard/overview/fetch_overview_use_case.dart'
    as fetch_overview_usecase;
import 'overview_constants.dart' as constants;

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc(
      {required this.fetchOverviewUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final fetch_overview_usecase.FetchOverviewUseCase fetchOverviewUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  @override
  Stream<OverviewState> mapEventToState(
    OverviewEvent event,
  ) async* {
    yield Loading();

    if (event is Fetch) {
      final fetchResponse = await fetchOverviewUseCase.fetch();
      fetchResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<OverviewState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<OverviewState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/dashboard/overview/fetch_overview_use_case.dart'
    as fetch_overview_usecase;

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc({required this.fetchOverviewUseCase}) : super(Empty());

  final fetch_overview_usecase.FetchOverviewUseCase fetchOverviewUseCase;

  @override
  Stream<OverviewState> mapEventToState(
    OverviewEvent event,
  ) async* {
    yield Loading();

    if (event is Fetch) {
      await fetchOverviewUseCase.fetch();
    }   
  }
}

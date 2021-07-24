import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc() : super(OverviewInitial());

  @override
  Stream<OverviewState> mapEventToState(
    OverviewEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

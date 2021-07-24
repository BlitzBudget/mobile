import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(Empty());

  @override
  Stream<BudgetState> mapEventToState(
    BudgetEvent event,
  ) async* {
    yield Loading();
  }
}

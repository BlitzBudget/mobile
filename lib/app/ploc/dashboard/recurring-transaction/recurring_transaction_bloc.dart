import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recurring_transaction_event.dart';
part 'recurring_transaction_state.dart';

class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  RecurringTransactionBloc() : super(Empty());

  @override
  Stream<RecurringTransactionState> mapEventToState(
    RecurringTransactionEvent event,
  ) async* {
    yield Loading();
  }
}

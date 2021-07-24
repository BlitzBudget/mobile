import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(Empty());

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    yield Loading();
  }
}

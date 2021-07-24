import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  BankAccountBloc() : super(Empty());

  @override
  Stream<BankAccountState> mapEventToState(
    BankAccountEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

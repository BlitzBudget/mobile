import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(Empty());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    yield Loading();
  }
}

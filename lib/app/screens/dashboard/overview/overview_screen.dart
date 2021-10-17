import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/Overview/Overview_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';

import 'components/body.dart';

class OverviewScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  BlocProvider<OverviewBloc> build(BuildContext context) {
    return BlocProvider(
      create: (_) => OverviewBloc(fetchOverviewUseCase: getIt()),
      child: const Scaffold(
        body: OverviewTab(),
      ),
    );
  }
}

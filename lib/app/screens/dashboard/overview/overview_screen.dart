import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi/mdi.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/overview/overview_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';

import 'components/body.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const title = 'Overview';
  static const androidIcon = Icon(Mdi.chartArc);
  static const iosIcon = Icon(Mdi.chartArc);

  @override
  BlocProvider<OverviewBloc> build(BuildContext context) {
    return BlocProvider(
        create: (_) => OverviewBloc(fetchOverviewUseCase: getIt()),
        child: const Scaffold(
          body: Body(),
        ));
  }
}

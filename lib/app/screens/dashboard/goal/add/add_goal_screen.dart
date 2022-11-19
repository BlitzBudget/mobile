import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';

import 'components/body.dart';

class AddGoalScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const AddGoalScreen({Key? key, this.androidDrawer}) : super(key: key);

  final Widget? androidDrawer;
  static const title = 'Goals';
  static const androidIcon = Icon(CupertinoIcons.news_solid);
  static const iosIcon = Icon(CupertinoIcons.news_solid);

  @override
  BlocProvider<GoalBloc> build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalBloc(
          updateGoalUseCase: getIt(),
          addGoalUseCase: getIt(),
          deleteGoalUseCase: getIt(),
          fetchGoalUseCase: getIt()),
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}

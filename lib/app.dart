import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'features/order/bloc/order_bloc.dart';
import 'features/order/bloc/order_event.dart';
import 'features/order/data/repositories/draft_repository.dart';
import 'features/order/data/repositories/submission_repository.dart';
import 'features/order/presentation/screens/order_form_screen.dart';

class BhumipunApp extends StatelessWidget {
  final DraftRepository draftRepository;
  final SubmissionRepository submissionRepository;

  const BhumipunApp({
    super.key,
    required this.draftRepository,
    required this.submissionRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      )..add(const OrderInitialized()),
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const OrderFormScreen(),
      ),
    );
  }
}

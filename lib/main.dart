import 'package:flutter/material.dart';

import 'app.dart';
import 'features/order/data/repositories/draft_repository.dart';
import 'features/order/data/repositories/submission_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final draftRepository = DraftRepository();
  final submissionRepository = SubmissionRepository();

  runApp(
    BhumipunApp(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    ),
  );
}

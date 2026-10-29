import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhumipun_demo/core/constants/app_theme.dart';
import 'package:bhumipun_demo/features/order/bloc/order_bloc.dart';
import 'package:bhumipun_demo/features/order/bloc/order_state.dart';
import 'package:bhumipun_demo/features/order/data/models/document_file_model.dart';
import 'package:bhumipun_demo/features/order/data/models/order_request_model.dart';
import 'package:bhumipun_demo/features/order/data/repositories/draft_repository.dart';
import 'package:bhumipun_demo/features/order/data/repositories/submission_repository.dart';
import 'package:bhumipun_demo/features/order/presentation/screens/order_form_screen.dart';
import 'package:bhumipun_demo/features/order/presentation/screens/submission_success_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DraftRepository draftRepository;
  late SubmissionRepository submissionRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    draftRepository = DraftRepository(prefs);
    submissionRepository = SubmissionRepository();
    Directory('screenshots').createSync(recursive: true);
  });

  Future<void> capturePng(
    WidgetTester tester,
    GlobalKey key,
    String filename,
  ) async {
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      await tester.runAsync(() async {
        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData != null) {
          final buffer = byteData.buffer.asUint8List();
          File('screenshots/$filename').writeAsBytesSync(buffer);
        }
      });
    }
  }

  const sampleOrder = OrderRequestModel(
    firstName: 'Jayesh',
    lastName: 'Patel',
    mobileNumber: '9876543210',
    email: 'jayesh.patel@bhumipun.in',
    orderId: 'ORD-2026-9042',
    address: 'Survey No. 42, Sanand-Viramgam Highway',
    state: 'Gujarat',
    district: 'Ahmedabad',
    taluka: 'Sanand',
    cityVillage: 'Moraiya',
    pinCode: '382110',
    aadhaarDoc: DocumentFileModel(
      name: 'aadhaar_jayesh_patel.pdf',
      sizeBytes: 1024 * 750,
      mimeType: 'application/pdf',
      isAccessible: true,
    ),
    supportingDoc: DocumentFileModel(
      name: 'land_extract_7_12.pdf',
      sizeBytes: 1024 * 1250,
      mimeType: 'application/pdf',
      isAccessible: true,
    ),
  );

  testWidgets('Generate Step 1 Mobile Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(420 * 2, 880 * 2);
    tester.view.devicePixelRatio = 2.0;

    final bloc = OrderBloc(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
    bloc.emit(const OrderState(currentStep: 0, order: sampleOrder));

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const OrderFormScreen()),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '01_step1_contact_details.png');
  });

  testWidgets('Generate Step 2 Mobile Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(420 * 2, 920 * 2);
    tester.view.devicePixelRatio = 2.0;

    final bloc = OrderBloc(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
    bloc.emit(const OrderState(currentStep: 1, order: sampleOrder));

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const OrderFormScreen()),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '02_step2_order_details.png');
  });

  testWidgets('Generate Step 3 Mobile Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(420 * 2, 880 * 2);
    tester.view.devicePixelRatio = 2.0;

    final bloc = OrderBloc(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
    bloc.emit(const OrderState(currentStep: 2, order: sampleOrder));

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const OrderFormScreen()),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '03_step3_document_uploads.png');
  });

  testWidgets('Generate Step 4 Mobile Review Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(420 * 2, 980 * 2);
    tester.view.devicePixelRatio = 2.0;

    final bloc = OrderBloc(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
    bloc.emit(const OrderState(currentStep: 3, order: sampleOrder));

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const OrderFormScreen()),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '04_step4_review_and_submit.png');
  });

  testWidgets('Generate Step 5 Submission Success Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(420 * 2, 980 * 2);
    tester.view.devicePixelRatio = 2.0;

    final result = SubmissionResult(
      success: true,
      referenceId: 'BHM-20261028-7492',
      timestamp: DateTime(2026, 10, 28, 15, 30),
      message:
          'Order request registered successfully in local demonstration mode.',
    );

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: SubmissionSuccessScreen(
            result: result,
            order: sampleOrder,
            onCreateAnother: () {},
          ),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '05_submission_success.png');
  });

  testWidgets('Generate Desktop Responsive View Screenshot', (tester) async {
    final repaintKey = GlobalKey();
    tester.view.physicalSize = const Size(1200 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;

    final bloc = OrderBloc(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
    bloc.emit(const OrderState(currentStep: 1, order: sampleOrder));

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const OrderFormScreen()),
        ),
      ),
    );

    await capturePng(tester, repaintKey, '06_responsive_desktop_view.png');
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhumipun_demo/app.dart';
import 'package:bhumipun_demo/core/constants/app_strings.dart';
import 'package:bhumipun_demo/features/order/data/models/document_file_model.dart';
import 'package:bhumipun_demo/features/order/data/models/order_request_model.dart';
import 'package:bhumipun_demo/features/order/data/repositories/draft_repository.dart';
import 'package:bhumipun_demo/features/order/data/repositories/submission_repository.dart';
import 'package:bhumipun_demo/features/order/presentation/screens/submission_success_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DraftRepository draftRepository;
  late SubmissionRepository submissionRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    draftRepository = DraftRepository(prefs);
    submissionRepository = SubmissionRepository();
  });

  Widget createTestWidget({OrderRequestModel? initialDraft}) {
    return BhumipunApp(
      draftRepository: draftRepository,
      submissionRepository: submissionRepository,
    );
  }

  group('OrderFormScreen - Widget Tests', () {
    testWidgets('renders Bhumipun Orders app bar and Step 1 fields', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify App Title
      expect(find.text(AppStrings.appTitle), findsOneWidget);

      // Verify Step 1 fields
      expect(find.text(AppStrings.step1Title), findsWidgets);
      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.mobileNumber), findsOneWidget);
      expect(find.text(AppStrings.emailAddress), findsOneWidget);

      // Verify Action Buttons
      expect(find.text(AppStrings.nextStep), findsOneWidget);
      expect(find.byTooltip('Save Draft'), findsWidgets);
    });

    testWidgets('shows validation errors when advancing on empty form', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Next Step without filling any fields
      await tester.tap(find.text(AppStrings.nextStep));
      await tester.pumpAndSettle();

      // Error snackbar or inline validation
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Please fill all valid contact details before continuing.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'fills valid contact details and successfully advances to Step 2',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter First Name
        await tester.enterText(
          find.widgetWithText(TextFormField, '').first,
          'Jayesh',
        );

        // Find fields by hints or text
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Jayesh');
        await tester.enterText(textFields.at(1), 'Patel');
        await tester.enterText(textFields.at(2), '9876543210');
        await tester.enterText(textFields.at(3), 'jayesh@agri.in');
        await tester.pumpAndSettle();

        // Tap Next Step
        await tester.tap(find.text(AppStrings.nextStep));
        await tester.pumpAndSettle();

        // Should now be on Step 2: Order Details
        expect(find.text(AppStrings.step2Title), findsWidgets);
        expect(find.text(AppStrings.state), findsOneWidget);
        expect(find.text(AppStrings.district), findsOneWidget);
        expect(find.text(AppStrings.taluka), findsOneWidget);
        expect(find.text(AppStrings.cityVillage), findsOneWidget);
        expect(find.text(AppStrings.pinCode), findsOneWidget);
      },
    );

    testWidgets('saves draft and displays success snackbar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Save Draft icon in app bar
      await tester.tap(find.byTooltip('Save Draft').first);
      await tester.pumpAndSettle();

      // Verify floating notification snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'Draft saved locally. You can safely close or resume anytime.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('submission success screen renders reference ID and summary', (
      tester,
    ) async {
      const order = OrderRequestModel(
        firstName: 'Dharmesh',
        lastName: 'Shah',
        mobileNumber: '9825012345',
        email: 'dharmesh@farm.in',
        orderId: 'ORD-2026-TEST',
        address: 'Plot 4, GIDC Sanand',
        state: 'Gujarat',
        district: 'Ahmedabad',
        taluka: 'Sanand',
        cityVillage: 'Moraiya',
        pinCode: '382110',
        aadhaarDoc: DocumentFileModel(
          name: 'aadhaar_dharmesh.pdf',
          sizeBytes: 1024 * 600,
        ),
        supportingDoc: DocumentFileModel(
          name: 'land_record.pdf',
          sizeBytes: 1024 * 800,
        ),
      );

      final result = SubmissionResult(
        success: true,
        referenceId: 'BHM-20261028-4912',
        timestamp: DateTime(2026, 10, 28, 15, 30),
        message: 'Order request registered successfully.',
      );

      bool resetCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SubmissionSuccessScreen(
            result: result,
            order: order,
            onCreateAnother: () {
              resetCalled = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Request Submitted!'), findsOneWidget);
      expect(find.text('BHM-20261028-4912'), findsOneWidget);
      expect(find.text(AppStrings.createAnother), findsOneWidget);

      // Tap Create Another Request
      await tester.ensureVisible(find.text(AppStrings.createAnother));
      await tester.tap(find.text(AppStrings.createAnother));
      await tester.pumpAndSettle();

      expect(resetCalled, isTrue);
    });
  });
}

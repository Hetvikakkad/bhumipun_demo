import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhumipun_demo/features/order/bloc/order_bloc.dart';
import 'package:bhumipun_demo/features/order/bloc/order_event.dart';
import 'package:bhumipun_demo/features/order/bloc/order_state.dart';
import 'package:bhumipun_demo/features/order/data/models/document_file_model.dart';
import 'package:bhumipun_demo/features/order/data/models/order_request_model.dart';
import 'package:bhumipun_demo/features/order/data/repositories/draft_repository.dart';
import 'package:bhumipun_demo/features/order/data/repositories/submission_repository.dart';

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

  group('OrderBloc - Step Navigation & Validation', () {
    blocTest<OrderBloc, OrderState>(
      'prevents progression to Step 1 if Contact Details are invalid',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      act: (bloc) => bloc.add(const OrderStepChanged(1)),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.currentStep, 'currentStep', 0)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'allows progression to Step 1 when Contact Details are valid',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () => const OrderState(
        order: OrderRequestModel(
          firstName: 'Rajesh',
          lastName: 'Patel',
          mobileNumber: '9876543210',
          email: 'rajesh.patel@agri.in',
        ),
      ),
      act: (bloc) => bloc.add(const OrderStepChanged(1)),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.currentStep, 'currentStep', 1)
            .having((s) => s.errorMessage, 'errorMessage', isNull),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'prevents progression to Step 2 if Order Details or Locations are incomplete',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () => const OrderState(
        currentStep: 1,
        order: OrderRequestModel(
          firstName: 'Rajesh',
          lastName: 'Patel',
          mobileNumber: '9876543210',
          email: 'rajesh.patel@agri.in',
          orderId: 'ORD-2026-101',
          address: 'Survey 24',
          // State and other location fields missing
        ),
      ),
      act: (bloc) => bloc.add(const OrderStepChanged(2)),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.currentStep, 'currentStep', 1)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'moving backward is always allowed and preserves state',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () => const OrderState(
        currentStep: 2,
        order: OrderRequestModel(
          firstName: 'Rajesh',
          lastName: 'Patel',
          mobileNumber: '9876543210',
          email: 'rajesh.patel@agri.in',
          orderId: 'ORD-2026-101',
          address: 'Survey No. 45, Sanand Road',
          state: 'Gujarat',
          district: 'Ahmedabad',
          taluka: 'Sanand',
          cityVillage: 'Moraiya',
          pinCode: '382110',
        ),
      ),
      act: (bloc) => bloc.add(const OrderStepChanged(0)),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.currentStep, 'currentStep', 0)
            .having((s) => s.order.firstName, 'firstName', 'Rajesh')
            .having((s) => s.order.cityVillage, 'cityVillage', 'Moraiya'),
      ],
    );
  });

  group('OrderBloc - Location Cascade Reset', () {
    blocTest<OrderBloc, OrderState>(
      'changing State resets District, Taluka, and CityVillage',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () => const OrderState(
        order: OrderRequestModel(
          state: 'Gujarat',
          district: 'Ahmedabad',
          taluka: 'Sanand',
          cityVillage: 'Moraiya',
        ),
      ),
      act: (bloc) => bloc.add(const StateChanged('Maharashtra')),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.order.state, 'state', 'Maharashtra')
            .having((s) => s.order.district, 'district', isNull)
            .having((s) => s.order.taluka, 'taluka', isNull)
            .having((s) => s.order.cityVillage, 'cityVillage', isNull),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'changing District resets Taluka and CityVillage',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () => const OrderState(
        order: OrderRequestModel(
          state: 'Gujarat',
          district: 'Ahmedabad',
          taluka: 'Sanand',
          cityVillage: 'Moraiya',
        ),
      ),
      act: (bloc) => bloc.add(const DistrictChanged('Surat')),
      expect: () => [
        isA<OrderState>()
            .having((s) => s.order.state, 'state', 'Gujarat')
            .having((s) => s.order.district, 'district', 'Surat')
            .having((s) => s.order.taluka, 'taluka', isNull)
            .having((s) => s.order.cityVillage, 'cityVillage', isNull),
      ],
    );
  });

  group('OrderBloc - Document Management', () {
    const validDoc = DocumentFileModel(
      name: 'aadhaar_card.pdf',
      sizeBytes: 1024 * 500,
      path: '/tmp/aadhaar_card.pdf',
    );

    blocTest<OrderBloc, OrderState>(
      'adds document when DocumentUpdated is received',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      act: (bloc) => bloc.add(
        const DocumentUpdated(type: DocumentType.aadhaar, document: validDoc),
      ),
      expect: () => [
        isA<OrderState>().having(
          (s) => s.order.aadhaarDoc?.name,
          'aadhaarDoc.name',
          'aadhaar_card.pdf',
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'removes document when DocumentRemoved is received',
      build: () => OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      ),
      seed: () =>
          const OrderState(order: OrderRequestModel(aadhaarDoc: validDoc)),
      act: (bloc) => bloc.add(const DocumentRemoved(DocumentType.aadhaar)),
      expect: () => [
        isA<OrderState>().having(
          (s) => s.order.aadhaarDoc,
          'aadhaarDoc',
          isNull,
        ),
      ],
    );
  });

  group('OrderBloc - Draft Persistence & Restoration', () {
    test(
      'saves draft to local storage and restores upon initialization',
      () async {
        final bloc = OrderBloc(
          draftRepository: draftRepository,
          submissionRepository: submissionRepository,
        );

        // 1. Enter details
        bloc.add(
          const ContactDetailsChanged(
            firstName: 'Suresh',
            lastName: 'Bhai',
            mobileNumber: '9123456780',
            email: 'suresh@farm.com',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        bloc.add(
          const OrderDetailsChanged(
            orderId: 'ORD-TEST-999',
            address: 'Farm Plot 12, Village Road',
            pinCode: '382110',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        // 2. Save draft
        bloc.add(const SaveDraftClicked());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.isDraftSaved, isTrue);

        // 3. New instance initializes and loads draft
        final newBloc = OrderBloc(
          draftRepository: draftRepository,
          submissionRepository: submissionRepository,
        );
        newBloc.add(const OrderInitialized());
        await Future.delayed(const Duration(milliseconds: 50));

        expect(newBloc.state.order.firstName, 'Suresh');
        expect(newBloc.state.order.orderId, 'ORD-TEST-999');
        expect(newBloc.state.order.email, 'suresh@farm.com');

        // 4. Clear draft
        newBloc.add(const ClearDraftClicked());
        await Future.delayed(const Duration(milliseconds: 50));

        final hasDraft = await draftRepository.hasDraft();
        expect(hasDraft, isFalse);
      },
    );
  });

  group('OrderBloc - Submission & Duplicate Prevention', () {
    const completeOrder = OrderRequestModel(
      firstName: 'Ramesh',
      lastName: 'Patel',
      mobileNumber: '9876543210',
      email: 'ramesh@bhumipun.in',
      orderId: 'ORD-2026-888',
      address: 'Survey No. 101, Agricultural Zone',
      state: 'Gujarat',
      district: 'Ahmedabad',
      taluka: 'Sanand',
      cityVillage: 'Moraiya',
      pinCode: '382110',
      aadhaarDoc: DocumentFileModel(
        name: 'aadhaar.pdf',
        sizeBytes: 1024 * 300,
        path: '/dummy/aadhaar.pdf',
      ),
      supportingDoc: DocumentFileModel(
        name: 'land_extract_7_12.pdf',
        sizeBytes: 1024 * 400,
        path: '/dummy/land_extract_7_12.pdf',
      ),
    );

    test('successfully submits valid order and clears saved draft', () async {
      final bloc = OrderBloc(
        draftRepository: draftRepository,
        submissionRepository: submissionRepository,
      );

      // Save a draft first
      await draftRepository.saveDraft(completeOrder);

      // Seed state
      bloc.emit(const OrderState(order: completeOrder, currentStep: 3));

      // Submit
      bloc.add(const SubmitOrderClicked());

      // Should enter submitting state
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.isSubmitting, isTrue);

      // Wait for mock submission delay
      await Future.delayed(const Duration(milliseconds: 1600));

      expect(bloc.state.isSubmitting, isFalse);
      expect(bloc.state.submissionSuccess, isTrue);
      expect(bloc.state.submissionResult, isNotNull);
      expect(bloc.state.submissionResult!.referenceId, startsWith('BHM-'));

      // Saved draft should be cleared after successful submission
      final draftExists = await draftRepository.hasDraft();
      expect(draftExists, isFalse);
    });

    test(
      'prevents duplicate submissions while submission is in progress',
      () async {
        final bloc = OrderBloc(
          draftRepository: draftRepository,
          submissionRepository: submissionRepository,
        );

        bloc.emit(const OrderState(order: completeOrder, currentStep: 3));

        bloc.add(const SubmitOrderClicked());
        await Future.delayed(const Duration(milliseconds: 10));

        // Trigger second submit while first is still running
        bloc.add(const SubmitOrderClicked());
        await Future.delayed(const Duration(milliseconds: 10));

        // State isSubmitting is true
        expect(bloc.state.isSubmitting, isTrue);

        await Future.delayed(const Duration(milliseconds: 1600));
        expect(bloc.state.submissionSuccess, isTrue);
      },
    );
  });
}

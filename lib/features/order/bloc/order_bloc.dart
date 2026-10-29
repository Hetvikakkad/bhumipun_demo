import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../data/models/document_file_model.dart';
import '../data/models/order_request_model.dart';
import '../data/repositories/draft_repository.dart';
import '../data/repositories/submission_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final DraftRepository draftRepository;
  final SubmissionRepository submissionRepository;

  OrderBloc({required this.draftRepository, required this.submissionRepository})
    : super(
        OrderState(
          order: OrderRequestModel(
            orderId: Formatters.generateInitialOrderId(),
          ),
        ),
      ) {
    on<OrderInitialized>(_onOrderInitialized);
    on<OrderStepChanged>(_onOrderStepChanged);
    on<ContactDetailsChanged>(_onContactDetailsChanged);
    on<OrderDetailsChanged>(_onOrderDetailsChanged);
    on<StateChanged>(_onStateChanged);
    on<DistrictChanged>(_onDistrictChanged);
    on<TalukaChanged>(_onTalukaChanged);
    on<CityVillageChanged>(_onCityVillageChanged);
    on<DocumentUpdated>(_onDocumentUpdated);
    on<DocumentRemoved>(_onDocumentRemoved);
    on<SaveDraftClicked>(_onSaveDraftClicked);
    on<ClearDraftClicked>(_onClearDraftClicked);
    on<SubmitOrderClicked>(_onSubmitOrderClicked);
    on<ResetFormClicked>(_onResetFormClicked);
    on<ClearNotification>(_onClearNotification);
  }

  Future<void> _onOrderInitialized(
    OrderInitialized event,
    Emitter<OrderState> emit,
  ) async {
    final draft = await draftRepository.loadDraft();
    if (draft != null) {
      final hasInaccessible =
          (draft.aadhaarDoc != null && !draft.aadhaarDoc!.isAccessible) ||
          (draft.supportingDoc != null && !draft.supportingDoc!.isAccessible);

      emit(
        state.copyWith(
          order: draft,
          hasInaccessibleFiles: hasInaccessible,
          notificationMessage: hasInaccessible
              ? 'Saved draft restored. Some previously attached files are no longer accessible and need re-selection.'
              : 'Draft restored from your last saved session.',
        ),
      );
    }
  }

  void _onOrderStepChanged(OrderStepChanged event, Emitter<OrderState> emit) {
    final targetStep = event.step;
    if (targetStep < 0 || targetStep > 3) return;

    // Moving backwards is always allowed and preserves state
    if (targetStep < state.currentStep) {
      emit(state.copyWith(currentStep: targetStep, clearErrorMessage: true));
      return;
    }

    // Moving forward requires earlier steps to be valid
    if (targetStep >= 1 && !state.order.isStep1Valid) {
      emit(
        state.copyWith(
          errorMessage:
              'Please fill all valid contact details before continuing.',
        ),
      );
      return;
    }

    if (targetStep >= 2 && !state.order.isStep2Valid) {
      emit(
        state.copyWith(
          errorMessage: 'Please complete order details and select valid location hierarchy.',
        ),
      );
      return;
    }

    if (targetStep >= 3 && !state.order.isStep3Valid) {
      emit(
        state.copyWith(
          errorMessage: 'Both Aadhaar and Supporting PDF documents are mandatory before reviewing.',
        ),
      );
      return;
    }

    emit(state.copyWith(currentStep: targetStep, clearErrorMessage: true));
  }

  void _onContactDetailsChanged(
    ContactDetailsChanged event,
    Emitter<OrderState> emit,
  ) {
    final updated = state.order.copyWith(
      firstName: event.firstName ?? state.order.firstName,
      lastName: event.lastName ?? state.order.lastName,
      mobileNumber: event.mobileNumber ?? state.order.mobileNumber,
      email: event.email ?? state.order.email,
    );
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onOrderDetailsChanged(
    OrderDetailsChanged event,
    Emitter<OrderState> emit,
  ) {
    final updated = state.order.copyWith(
      orderId: event.orderId ?? state.order.orderId,
      address: event.address ?? state.order.address,
      pinCode: event.pinCode ?? state.order.pinCode,
    );
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onStateChanged(StateChanged event, Emitter<OrderState> emit) {
    // Reset dependent selections when state changes
    final updated = state.order.copyWith(
      state: event.state,
      clearDistrict: true,
      clearTaluka: true,
      clearCityVillage: true,
    );
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onDistrictChanged(DistrictChanged event, Emitter<OrderState> emit) {
    // Reset dependent selections when district changes
    final updated = state.order.copyWith(
      district: event.district,
      clearTaluka: true,
      clearCityVillage: true,
    );
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onTalukaChanged(TalukaChanged event, Emitter<OrderState> emit) {
    // Reset dependent selections when taluka changes
    final updated = state.order.copyWith(
      taluka: event.taluka,
      clearCityVillage: true,
    );
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onCityVillageChanged(
    CityVillageChanged event,
    Emitter<OrderState> emit,
  ) {
    final updated = state.order.copyWith(cityVillage: event.cityVillage);
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onDocumentUpdated(DocumentUpdated event, Emitter<OrderState> emit) {
    final OrderRequestModel updated;
    if (event.type == DocumentType.aadhaar) {
      updated = state.order.copyWith(aadhaarDoc: event.document);
    } else {
      updated = state.order.copyWith(supportingDoc: event.document);
    }
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  void _onDocumentRemoved(DocumentRemoved event, Emitter<OrderState> emit) {
    final OrderRequestModel updated;
    if (event.type == DocumentType.aadhaar) {
      updated = state.order.copyWith(clearAadhaar: true);
    } else {
      updated = state.order.copyWith(clearSupporting: true);
    }
    emit(state.copyWith(order: updated, clearErrorMessage: true));
  }

  Future<void> _onSaveDraftClicked(
    SaveDraftClicked event,
    Emitter<OrderState> emit,
  ) async {
    final saved = await draftRepository.saveDraft(state.order);
    if (saved) {
      emit(
        state.copyWith(
          isDraftSaved: true,
          notificationMessage:
              'Draft saved locally. You can safely close or resume anytime.',
        ),
      );
    } else {
      emit(
        state.copyWith(errorMessage: 'Failed to save draft to local storage.'),
      );
    }
  }

  Future<void> _onClearDraftClicked(
    ClearDraftClicked event,
    Emitter<OrderState> emit,
  ) async {
    await draftRepository.clearDraft();
    emit(
      OrderState(
        order: OrderRequestModel(orderId: Formatters.generateInitialOrderId()),
        currentStep: 0,
        notificationMessage: 'Draft cleared. Started a fresh order request.',
      ),
    );
  }

  Future<void> _onSubmitOrderClicked(
    SubmitOrderClicked event,
    Emitter<OrderState> emit,
  ) async {
    // Prevent duplicate submissions
    if (state.isSubmitting || state.submissionSuccess) {
      return;
    }

    if (!state.order.isStep1Valid) {
      emit(
        state.copyWith(
          currentStep: 0,
          errorMessage:
              'Contact details are invalid. Please correct required fields.',
        ),
      );
      return;
    }
    if (!state.order.isStep2Valid) {
      emit(
        state.copyWith(
          currentStep: 1,
          errorMessage: 'Order details or locations are incomplete. Please complete all fields.',
        ),
      );
      return;
    }
    if (!state.order.isStep3Valid) {
      emit(
        state.copyWith(
          currentStep: 2,
          errorMessage:
              'Both Aadhaar and Supporting PDF documents are required.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    try {
      final result = await submissionRepository.submitOrder(state.order);
      // Clean up saved draft after successful submission
      await draftRepository.clearDraft();

      emit(
        state.copyWith(
          isSubmitting: false,
          submissionSuccess: true,
          submissionResult: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _onResetFormClicked(ResetFormClicked event, Emitter<OrderState> emit) {
    emit(
      OrderState(
        order: OrderRequestModel(orderId: Formatters.generateInitialOrderId()),
        currentStep: 0,
      ),
    );
  }

  void _onClearNotification(ClearNotification event, Emitter<OrderState> emit) {
    emit(state.copyWith(clearNotification: true, clearErrorMessage: true));
  }
}

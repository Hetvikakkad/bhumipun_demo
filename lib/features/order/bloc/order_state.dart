import 'package:equatable/equatable.dart';

import '../data/models/order_request_model.dart';
import '../data/repositories/submission_repository.dart';

class OrderState extends Equatable {
  final int currentStep; // 0: Contact, 1: Order, 2: Documents, 3: Review
  final OrderRequestModel order;
  final bool isSubmitting;
  final bool submissionSuccess;
  final SubmissionResult? submissionResult;
  final String? errorMessage;
  final String? notificationMessage;
  final bool hasInaccessibleFiles;
  final bool isDraftSaved;

  const OrderState({
    this.currentStep = 0,
    this.order = const OrderRequestModel(),
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.submissionResult,
    this.errorMessage,
    this.notificationMessage,
    this.hasInaccessibleFiles = false,
    this.isDraftSaved = false,
  });

  bool get isStep1Valid => order.isStep1Valid;
  bool get isStep2Valid => order.isStep2Valid;
  bool get isStep3Valid => order.isStep3Valid;
  bool get canProceedFromCurrentStep {
    switch (currentStep) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      case 2:
        return isStep3Valid;
      case 3:
        return order.isReadyForSubmission;
      default:
        return false;
    }
  }

  OrderState copyWith({
    int? currentStep,
    OrderRequestModel? order,
    bool? isSubmitting,
    bool? submissionSuccess,
    SubmissionResult? submissionResult,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? notificationMessage,
    bool clearNotification = false,
    bool? hasInaccessibleFiles,
    bool? isDraftSaved,
  }) {
    return OrderState(
      currentStep: currentStep ?? this.currentStep,
      order: order ?? this.order,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      submissionResult: submissionResult ?? this.submissionResult,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      notificationMessage: clearNotification
          ? null
          : (notificationMessage ?? this.notificationMessage),
      hasInaccessibleFiles: hasInaccessibleFiles ?? this.hasInaccessibleFiles,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    order,
    isSubmitting,
    submissionSuccess,
    submissionResult,
    errorMessage,
    notificationMessage,
    hasInaccessibleFiles,
    isDraftSaved,
  ];
}

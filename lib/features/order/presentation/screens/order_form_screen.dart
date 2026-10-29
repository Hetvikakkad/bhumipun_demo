import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../bloc/order_bloc.dart';
import '../../bloc/order_event.dart';
import '../../bloc/order_state.dart';
import '../widgets/contact_details_step.dart';
import '../widgets/document_uploads_step.dart';
import '../widgets/order_details_step.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/review_and_submit_step.dart';
import '../widgets/step_header.dart';
import 'submission_success_screen.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showClearDraftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.errorRed),
            SizedBox(width: 8),
            Text('Clear Draft?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear your saved draft? All entered fields will be reset.',
          style: TextStyle(color: AppColors.charcoalMuted, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<OrderBloc>().add(const ClearDraftClicked());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('Clear Draft'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.notificationMessage != current.notificationMessage ||
          previous.submissionSuccess != current.submissionSuccess,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.errorMessage!)),
                ],
              ),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<OrderBloc>().add(const ClearNotification());
        } else if (state.notificationMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.notificationMessage!)),
                ],
              ),
              backgroundColor: AppColors.forestGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<OrderBloc>().add(const ClearNotification());
        }
      },
      builder: (context, state) {
        if (state.submissionSuccess && state.submissionResult != null) {
          return SubmissionSuccessScreen(
            result: state.submissionResult!,
            order: state.order,
            onCreateAnother: () {
              context.read<OrderBloc>().add(const ResetFormClicked());
            },
          );
        }

        return Scaffold(
          backgroundColor: AppColors.warmIvory,
          appBar: _buildAppBar(context, state),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktopLayout = constraints.maxWidth >= 900;

              return SafeArea(
                child: isDesktopLayout
                    ? _buildDesktopLayout(context, state)
                    : _buildMobileLayout(context, state),
              );
            },
          ),
          bottomNavigationBar: _buildBottomBar(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, OrderState state) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.forestGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Flexible(
            child: Text(
              AppStrings.appTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Save Draft action
        IconButton(
          onPressed: () =>
              context.read<OrderBloc>().add(const SaveDraftClicked()),
          icon: const Icon(Icons.bookmark_border_rounded),
          tooltip: 'Save Draft',
          color: AppColors.forestGreen,
        ),
        // Clear Draft action
        IconButton(
          onPressed: () => _showClearDraftDialog(context),
          icon: const Icon(Icons.delete_sweep_outlined),
          tooltip: 'Clear Draft',
          color: AppColors.charcoalMuted,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Mobile & Tablet portrait layout: single column with stepper header.
  Widget _buildMobileLayout(BuildContext context, OrderState state) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          StepHeader(
            currentStep: state.currentStep,
            onStepTapped: (index) {
              context.read<OrderBloc>().add(OrderStepChanged(index));
            },
          ),
          const SizedBox(height: 16),
          _buildActiveStepContent(context, state),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Desktop & Tablet landscape layout: side-by-side with sticky live Order Summary panel.
  Widget _buildDesktopLayout(BuildContext context, OrderState state) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Active Step Form
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StepHeader(
                        currentStep: state.currentStep,
                        onStepTapped: (index) {
                          context.read<OrderBloc>().add(
                            OrderStepChanged(index),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActiveStepContent(context, state),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Right side: Sticky Live Order Summary Panel
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: OrderSummaryCard(
                    order: state.order,
                    onEditStep: (step) {
                      context.read<OrderBloc>().add(OrderStepChanged(step));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStepContent(BuildContext context, OrderState state) {
    final bloc = context.read<OrderBloc>();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(state.currentStep),
            child: _getStepWidget(state, bloc),
          ),
        ),
      ),
    );
  }

  Widget _getStepWidget(OrderState state, OrderBloc bloc) {
    switch (state.currentStep) {
      case 0:
        return ContactDetailsStep(
          order: state.order,
          onContactChanged: ({firstName, lastName, mobileNumber, email}) {
            bloc.add(
              ContactDetailsChanged(
                firstName: firstName,
                lastName: lastName,
                mobileNumber: mobileNumber,
                email: email,
              ),
            );
          },
        );
      case 1:
        return OrderDetailsStep(
          order: state.order,
          onOrderDetailsChanged: ({orderId, address, pinCode}) {
            bloc.add(
              OrderDetailsChanged(
                orderId: orderId,
                address: address,
                pinCode: pinCode,
              ),
            );
          },
          onStateChanged: (val) => bloc.add(StateChanged(val)),
          onDistrictChanged: (val) => bloc.add(DistrictChanged(val)),
          onTalukaChanged: (val) => bloc.add(TalukaChanged(val)),
          onCityVillageChanged: (val) => bloc.add(CityVillageChanged(val)),
        );
      case 2:
        return DocumentUploadsStep(
          order: state.order,
          hasInaccessibleFiles: state.hasInaccessibleFiles,
          onDocumentSelected: (type, doc) {
            bloc.add(DocumentUpdated(type: type, document: doc));
          },
          onDocumentRemoved: (type) {
            bloc.add(DocumentRemoved(type));
          },
        );
      case 3:
      default:
        return ReviewAndSubmitStep(
          order: state.order,
          onEditStep: (step) {
            bloc.add(OrderStepChanged(step));
          },
        );
    }
  }

  Widget _buildBottomBar(BuildContext context, OrderState state) {
    final bloc = context.read<OrderBloc>();
    final isLastStep = state.currentStep == 3;
    final isFirstStep = state.currentStep == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Back button
            if (!isFirstStep) ...[
              OutlinedButton.icon(
                onPressed: state.isSubmitting
                    ? null
                    : () {
                        bloc.add(OrderStepChanged(state.currentStep - 1));
                      },
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text(AppStrings.previousStep),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Save draft button
            IconButton.outlined(
              onPressed: state.isSubmitting
                  ? null
                  : () {
                      bloc.add(const SaveDraftClicked());
                    },
              icon: const Icon(Icons.bookmark_border_rounded, size: 20),
              tooltip: 'Save Draft',
              color: AppColors.forestGreen,
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.borderLight),
                padding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(width: 12),

            // Continue or Submit Button
            Expanded(
              child: ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () {
                        if (isLastStep) {
                          bloc.add(const SubmitOrderClicked());
                        } else {
                          // Validate form before advancing
                          if (_formKey.currentState?.validate() ?? false) {
                            bloc.add(OrderStepChanged(state.currentStep + 1));
                          } else {
                            bloc.add(OrderStepChanged(state.currentStep + 1));
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastStep
                      ? AppColors.terracotta
                      : AppColors.forestGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              isLastStep
                                  ? 'Submit Request'
                                  : AppStrings.nextStep,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isLastStep
                                ? Icons.check_circle_outline_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

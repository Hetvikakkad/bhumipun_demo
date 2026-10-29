import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/order_request_model.dart';
import '../../data/repositories/submission_repository.dart';
import '../widgets/order_summary_card.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  final SubmissionResult result;
  final OrderRequestModel order;
  final VoidCallback onCreateAnother;

  const SubmissionSuccessScreen({
    super.key,
    required this.result,
    required this.order,
    required this.onCreateAnother,
  });

  void _copyReference(BuildContext context) {
    Clipboard.setData(ClipboardData(text: result.referenceId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reference ID copied to clipboard!'),
        backgroundColor: AppColors.forestGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: AppBar(
        title: const Text('Request Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: onCreateAnother,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                children: [
                  // Celebration Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.forestGreen.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Animated-style Success Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.forestGreenLight,
                            border: Border.all(
                              color: AppColors.forestGreen.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.forestGreen,
                              size: 48,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Order Request Submitted!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your order request has been processed and saved locally.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.charcoalMuted,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Reference ID Highlight Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreenSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.forestGreen.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'REQUEST REFERENCE ID',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.forestGreenDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SelectableText(
                                result.referenceId,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.forestGreen,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Submitted on ${Formatters.formatDateTime(result.timestamp)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.charcoalMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () => _copyReference(context),
                                icon: const Icon(Icons.copy_rounded, size: 16),
                                label: const Text('Copy Reference ID'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.forestGreen,
                                  side: const BorderSide(
                                    color: AppColors.forestGreen,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Demonstration Mode Disclaimer Banner
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                color: AppColors.forestGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Demonstration Mode Notice: This reference was generated locally. '
                                  'Aadhaar document data is not stored in external repositories.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.charcoalMuted.withValues(
                                      alpha: 0.9,
                                    ),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submitted Order Summary Card
                  OrderSummaryCard(order: order),

                  const SizedBox(height: 28),

                  // "Create Another Request" Call to action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onCreateAnother,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(AppStrings.createAnother),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.terracotta,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

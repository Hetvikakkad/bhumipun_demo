import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/order_request_model.dart';
import 'order_summary_card.dart';

class ReviewAndSubmitStep extends StatelessWidget {
  final OrderRequestModel order;
  final void Function(int) onEditStep;

  const ReviewAndSubmitStep({
    super.key,
    required this.order,
    required this.onEditStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.forestGreenSubtle,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.forestGreen.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                color: AppColors.forestGreen,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.step4Title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppStrings.step4Subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Order Summary Card
        OrderSummaryCard(order: order, onEditStep: onEditStep),
      ],
    );
  }
}

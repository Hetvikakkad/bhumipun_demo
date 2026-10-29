import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final void Function(int) onStepTapped;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  static const List<Map<String, String>> steps = [
    {'title': 'Contact', 'full': 'Contact Details', 'icon': '1'},
    {'title': 'Order', 'full': 'Order Details', 'icon': '2'},
    {'title': 'Documents', 'full': 'Document Uploads', 'icon': '3'},
    {'title': 'Review', 'full': 'Review & Submit', 'icon': '4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 450;

          return Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepIndex = index ~/ 2;
                final isCompleted = stepIndex < currentStep;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: isCompleted
                        ? AppColors.forestGreen
                        : AppColors.borderLight,
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final isActive = stepIndex == currentStep;
              final isCompleted = stepIndex < currentStep;
              final stepData = steps[stepIndex];

              return InkWell(
                onTap: isCompleted ? () => onStepTapped(stepIndex) : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? AppColors.forestGreen
                              : isActive
                              ? AppColors.terracotta
                              : AppColors.surfaceWarm,
                          border: Border.all(
                            color: isActive
                                ? AppColors.terracottaDark
                                : isCompleted
                                ? AppColors.forestGreen
                                : AppColors.borderLight,
                            width: isActive ? 2 : 1,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.terracotta.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Text(
                                  '${stepIndex + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.charcoalMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (!isCompact) ...[
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Step ${stepIndex + 1}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? AppColors.terracotta
                                    : AppColors.charcoalLight,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              stepData['title']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.charcoal
                                    : AppColors.charcoalMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

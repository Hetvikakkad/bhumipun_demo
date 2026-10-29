import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/order_request_model.dart';
import 'custom_text_field.dart';

class ContactDetailsStep extends StatelessWidget {
  final OrderRequestModel order;
  final void Function({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? email,
  })
  onContactChanged;

  const ContactDetailsStep({
    super.key,
    required this.order,
    required this.onContactChanged,
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
                Icons.person_pin_rounded,
                color: AppColors.forestGreen,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.step1Title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppStrings.step1Subtitle,
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

        // First Name & Last Name (Side by side on wider screens, stacked on small)
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 480;

            if (isSmall) {
              return Column(
                children: [
                  CustomTextField(
                    label: AppStrings.firstName,
                    hint: 'Enter your first name',
                    initialValue: order.firstName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s.'-]"),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (val) =>
                        Validators.validateName(val, AppStrings.firstName),
                    onChanged: (val) => onContactChanged(firstName: val),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.lastName,
                    hint: 'Enter your last name',
                    initialValue: order.lastName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s.'-]"),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (val) =>
                        Validators.validateName(val, AppStrings.lastName),
                    onChanged: (val) => onContactChanged(lastName: val),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.firstName,
                    hint: 'First name',
                    initialValue: order.firstName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s.'-]"),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (val) =>
                        Validators.validateName(val, AppStrings.firstName),
                    onChanged: (val) => onContactChanged(firstName: val),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.lastName,
                    hint: 'Last name',
                    initialValue: order.lastName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s.'-]"),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (val) =>
                        Validators.validateName(val, AppStrings.lastName),
                    onChanged: (val) => onContactChanged(lastName: val),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Mobile Number with +91 indicator
        CustomTextField(
          label: AppStrings.mobileNumber,
          hint: '',
          initialValue: order.mobileNumber,
          keyboardType: TextInputType.phone,
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.borderLight)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🇮🇳 +91',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          helperText:
              '10-digit Indian mobile number starting with 6, 7, 8, or 9',
          validator: Validators.validateIndianMobile,
          onChanged: (val) => onContactChanged(mobileNumber: val),
        ),

        const SizedBox(height: 16),

        // Email Address
        CustomTextField(
          label: AppStrings.emailAddress,
          hint: '',
          initialValue: order.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, size: 20),
          validator: Validators.validateEmail,
          onChanged: (val) => onContactChanged(email: val),
        ),
      ],
    );
  }
}

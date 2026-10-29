import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/order_request_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderRequestModel order;
  final void Function(int stepIndex)? onEditStep;
  final bool isCompact;

  const OrderSummaryCard({
    super.key,
    required this.order,
    this.onEditStep,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.forestGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.forestGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Request Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    Text(
                      'Verify all information before submission',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 28),

          // 1. Contact Details Section
          _buildSectionHeader(
            icon: Icons.person_outline_rounded,
            title: '1. Contact Information',
            stepIndex: 0,
            isValid: order.isStep1Valid,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            'Name',
            order.fullName.isNotEmpty ? order.fullName : '—',
          ),
          _buildInfoRow(
            'Mobile',
            order.mobileNumber.isNotEmpty
                ? Formatters.formatIndianPhone(order.mobileNumber)
                : '—',
          ),
          _buildInfoRow('Email', order.email.isNotEmpty ? order.email : '—'),

          const Divider(height: 28),

          // 2. Order & Location Details Section
          _buildSectionHeader(
            icon: Icons.location_on_outlined,
            title: '2. Order & Location Details',
            stepIndex: 1,
            isValid: order.isStep2Valid,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            'Order ID',
            order.orderId.isNotEmpty ? order.orderId : '—',
            isHighlight: true,
          ),
          _buildInfoRow(
            'Address',
            order.address.isNotEmpty ? order.address : '—',
          ),
          _buildInfoRow('State', order.state ?? '—'),
          _buildInfoRow('District', order.district ?? '—'),
          _buildInfoRow('Taluka', order.taluka ?? '—'),
          _buildInfoRow('City / Village', order.cityVillage ?? '—'),
          _buildInfoRow(
            'PIN Code',
            order.pinCode.isNotEmpty ? order.pinCode : '—',
          ),

          const Divider(height: 28),

          // 3. Document Verification Section
          _buildSectionHeader(
            icon: Icons.folder_outlined,
            title: '3. Mandatory Documents',
            stepIndex: 2,
            isValid: order.isStep3Valid,
          ),
          const SizedBox(height: 10),
          _buildDocRow(
            'Aadhaar Card',
            order.aadhaarDoc?.name,
            order.aadhaarDoc?.formattedSize,
          ),
          const SizedBox(height: 8),
          _buildDocRow(
            'Supporting Document',
            order.supportingDoc?.name,
            order.supportingDoc?.formattedSize,
          ),

          const SizedBox(height: 20),

          // Local Demonstration Mode Disclaimer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.forestGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.demoNotice,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.charcoalMuted.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int stepIndex,
    required bool isValid,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isValid ? AppColors.forestGreen : AppColors.charcoalMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
        ),
        if (isValid)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.forestGreenLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 12, color: AppColors.forestGreen),
                SizedBox(width: 2),
                Text(
                  'Valid',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.forestGreenDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (onEditStep != null) ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: () => onEditStep!(stepIndex),
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.charcoalMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                color: isHighlight
                    ? AppColors.forestGreenDark
                    : AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRow(String label, String? fileName, String? size) {
    final hasDoc = fileName != null && fileName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: hasDoc ? AppColors.forestGreenSubtle : AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasDoc
              ? AppColors.forestGreen.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasDoc
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: hasDoc ? AppColors.forestGreen : AppColors.charcoalLight,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoalMuted,
                  ),
                ),
                Text(
                  hasDoc ? fileName : 'Not attached yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: hasDoc ? AppColors.charcoal : AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
          if (hasDoc && size != null)
            Text(
              size,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.charcoalMuted,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../data/locations_data.dart';
import '../../data/models/order_request_model.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';

class OrderDetailsStep extends StatelessWidget {
  final OrderRequestModel order;
  final void Function({String? orderId, String? address, String? pinCode})
  onOrderDetailsChanged;
  final void Function(String?) onStateChanged;
  final void Function(String?) onDistrictChanged;
  final void Function(String?) onTalukaChanged;
  final void Function(String?) onCityVillageChanged;

  const OrderDetailsStep({
    super.key,
    required this.order,
    required this.onOrderDetailsChanged,
    required this.onStateChanged,
    required this.onDistrictChanged,
    required this.onTalukaChanged,
    required this.onCityVillageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final availableDistricts = LocationsData.getDistricts(order.state);
    final availableTalukas = LocationsData.getTalukas(
      order.state,
      order.district,
    );
    final availableCities = LocationsData.getCities(
      order.state,
      order.district,
      order.taluka,
    );

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
                Icons.inventory_2_outlined,
                color: AppColors.forestGreen,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.step2Title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppStrings.step2Subtitle,
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

        // Order ID Field
        CustomTextField(
          label: AppStrings.orderId,
          hint: 'e.g. ORD-2026-9042',
          initialValue: order.orderId,
          prefixIcon: const Icon(Icons.tag_rounded, size: 20),
          validator: (val) =>
              Validators.validateRequired(val, AppStrings.orderId),
          onChanged: (val) => onOrderDetailsChanged(orderId: val),
          helperText:
              'Unique identifier for tracking this land or supply order',
        ),

        const SizedBox(height: 16),

        // Full Street Address
        CustomTextField(
          label: AppStrings.fullAddress,
          hint: 'Survey No., Farm House / Flat, Street / Road name',
          initialValue: order.address,
          maxLines: 2,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Icon(Icons.home_outlined, size: 20),
          ),
          validator: Validators.validateAddress,
          onChanged: (val) => onOrderDetailsChanged(address: val),
        ),

        const SizedBox(height: 16),

        // State Dropdown
        CustomDropdown(
          label: AppStrings.state,
          hint: 'Select State',
          value: order.state,
          items: LocationsData.states,
          onChanged: onStateChanged,
          validator: (val) =>
              Validators.validateRequired(val, AppStrings.state),
        ),

        const SizedBox(height: 16),

        // District Dropdown (Dependent on State)
        CustomDropdown(
          label: AppStrings.district,
          hint: order.state == null ? 'Select State first' : 'Select District',
          disabledHint: 'Select State first',
          enabled: order.state != null && availableDistricts.isNotEmpty,
          value: order.district,
          items: availableDistricts,
          onChanged: onDistrictChanged,
          validator: (val) =>
              Validators.validateRequired(val, AppStrings.district),
        ),

        const SizedBox(height: 16),

        // Taluka & City/Village in a 2-column layout or stacked
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 480;

            if (isSmall) {
              return Column(
                children: [
                  CustomDropdown(
                    label: AppStrings.taluka,
                    hint: order.district == null
                        ? 'Select District first'
                        : 'Select Taluka',
                    disabledHint: 'Select District first',
                    enabled:
                        order.district != null && availableTalukas.isNotEmpty,
                    value: order.taluka,
                    items: availableTalukas,
                    onChanged: onTalukaChanged,
                    validator: (val) =>
                        Validators.validateRequired(val, AppStrings.taluka),
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown(
                    label: AppStrings.cityVillage,
                    hint: order.taluka == null
                        ? 'Select Taluka first'
                        : 'Select City / Village',
                    disabledHint: 'Select Taluka first',
                    enabled: order.taluka != null && availableCities.isNotEmpty,
                    value: order.cityVillage,
                    items: availableCities,
                    onChanged: onCityVillageChanged,
                    validator: (val) => Validators.validateRequired(
                      val,
                      AppStrings.cityVillage,
                    ),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: AppStrings.taluka,
                    hint: order.district == null
                        ? 'Select District'
                        : 'Select Taluka',
                    disabledHint: 'Select District first',
                    enabled:
                        order.district != null && availableTalukas.isNotEmpty,
                    value: order.taluka,
                    items: availableTalukas,
                    onChanged: onTalukaChanged,
                    validator: (val) =>
                        Validators.validateRequired(val, AppStrings.taluka),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDropdown(
                    label: AppStrings.cityVillage,
                    hint: order.taluka == null
                        ? 'Select Taluka'
                        : 'Select City / Village',
                    disabledHint: 'Select Taluka first',
                    enabled: order.taluka != null && availableCities.isNotEmpty,
                    value: order.cityVillage,
                    items: availableCities,
                    onChanged: onCityVillageChanged,
                    validator: (val) => Validators.validateRequired(
                      val,
                      AppStrings.cityVillage,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // PIN Code
        CustomTextField(
          label: AppStrings.pinCode,
          hint: 'e.g. 382110',
          initialValue: order.pinCode,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.pin_drop_outlined, size: 20),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          helperText: '6-digit Indian Postal Identification Number',
          validator: Validators.validatePinCode,
          onChanged: (val) => onOrderDetailsChanged(pinCode: val),
        ),
      ],
    );
  }
}

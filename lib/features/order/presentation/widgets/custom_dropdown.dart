import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool enabled;
  final String? disabledHint;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isRequired = true,
    this.enabled = true,
    this.disabledHint,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && items.isNotEmpty;
    // Ensure selected value actually exists in items, otherwise treat as null
    final effectiveValue = items.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
                letterSpacing: 0.1,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          key: ValueKey('${label}_${items.length}_$effectiveValue'),
          initialValue: effectiveValue,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(
            hintText: effectiveEnabled ? hint : (disabledHint ?? hint),
            filled: true,
            fillColor: effectiveEnabled ? Colors.white : AppColors.surfaceWarm,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.charcoalMuted,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: effectiveEnabled
              ? items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.charcoal,
                      ),
                    ),
                  );
                }).toList()
              : null,
          onChanged: effectiveEnabled ? onChanged : null,
        ),
      ],
    );
  }
}

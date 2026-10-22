import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../home/models/financing_solution_model.dart';

class LoanTypeField extends StatelessWidget {
  final String? initialValue;
  final List<FinancingSolutionModel> products;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const LoanTypeField({
    super.key,
    required this.initialValue,
    required this.products,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.tr('Loan Type'),
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: initialValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.outline),
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          dropdownColor: AppColors.surfaceContainerLowest,
          decoration: InputDecoration(
            hintText: context.tr('Select loan type'),
            prefixIcon: const Icon(
              Icons.account_balance_outlined,
              size: 20,
              color: AppColors.outline,
            ),
          ),
          items: products
              .where((product) => product.applicationEnabled)
              .map(
                (product) => DropdownMenuItem(
                  value: product.id,
                  child: Text(context.tr(product.title)),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          validator: (value) =>
              value == null ? context.tr('Please select a loan type') : null,
        ),
        const SizedBox(height: 4),
        Text(
          context.tr('Auto-filled from the facility you selected'),
          style: AppTypography.caption.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

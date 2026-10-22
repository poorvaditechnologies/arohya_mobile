import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable text field matching the Arohya design system.
///
/// Features: optional prefix (e.g. "+91"), suffix icons, helper text,
/// and error styling that integrates with the centralized theme.
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: prefix,
                  )
                : null,
            prefixIconConstraints: prefix != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: suffix,
            counterText: '',
          ),
        ),
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

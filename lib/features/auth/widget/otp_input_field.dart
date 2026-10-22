import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Six-box one-time-code input.
///
/// Each digit is drawn in its own box, while a single invisible [TextField]
/// sits on top and owns the real input. That keeps typing, backspace, paste
/// and OS autofill (`oneTimeCode`) working without juggling six focus nodes.
///
/// Animations:
/// - boxes fade/slide in one after another on first build
/// - the active box is highlighted and shows a blinking caret
/// - every typed digit pops in
/// - [shake] wiggles the row horizontally (wrong code)
/// - [playSuccess] ripples a bounce across the boxes (correct code)
///
/// Call [shake] / [playSuccess] through a `GlobalKey<OtpInputFieldState>`.
class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;

  /// Paints the boxes in the error colour.
  final bool hasError;

  /// Paints the boxes in the success colour.
  final bool isSuccess;

  /// When false the field ignores input (e.g. while verifying).
  final bool enabled;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.length = 6,
    this.hasError = false,
    this.isSuccess = false,
    this.enabled = true,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField>
    with TickerProviderStateMixin {
  static const double _boxHeight = 60;
  static const double _gap = 10;

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final AnimationController _success = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
    _entrance.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    _entrance.dispose();
    _shake.dispose();
    _success.dispose();
    super.dispose();
  }

  /// Wiggles the boxes left and right.
  Future<void> shake() async {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    await _shake.forward(from: 0);
  }

  /// Bounces the boxes one after another.
  Future<void> playSuccess() async {
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    await _success.forward(from: 0);
  }

  void _onTextChanged() {
    // Keep the caret at the end so a stray tap can't edit mid-code.
    final text = widget.controller.text;
    if (widget.controller.selection.baseOffset != text.length) {
      widget.controller.selection = TextSelection.collapsed(
        offset: text.length,
      );
    }
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  Future<void> _pasteFromClipboard() async {
    if (!widget.enabled) return;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final digits = (data?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    final code = digits.substring(0, math.min(widget.length, digits.length));
    widget.controller.text = code;
    _handleChanged(code);
  }

  Color _borderColor(bool isActive, bool isFilled) {
    if (widget.isSuccess) return AppColors.success;
    if (widget.hasError) return AppColors.error;
    if (isActive) return AppColors.primaryContainer;
    if (isFilled) return AppColors.primaryContainer.withValues(alpha: 0.5);
    return AppColors.outlineVariant;
  }

  Color _fillColor() {
    if (widget.isSuccess) return AppColors.successBg;
    if (widget.hasError) {
      return AppColors.errorContainer.withValues(alpha: 0.35);
    }
    return AppColors.surfaceContainerLowest;
  }

  Color _digitColor() {
    if (widget.isSuccess) return AppColors.success;
    if (widget.hasError) return AppColors.error;
    return AppColors.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final hasFocus = widget.focusNode.hasFocus;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = math.min(
          52.0,
          (constraints.maxWidth - _gap * (widget.length - 1)) / widget.length,
        );

        return AnimatedBuilder(
          animation: Listenable.merge([_entrance, _shake, _success]),
          builder: (context, _) {
            // Damped sine wave: 3 full wiggles that fade out.
            final shakeT = _shake.value;
            final shakeDx = math.sin(shakeT * math.pi * 6) * 12 * (1 - shakeT);

            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(shakeDx, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < widget.length; i++) ...[
                        if (i > 0) const SizedBox(width: _gap),
                        _buildBox(
                          index: i,
                          width: boxWidth,
                          digit: i < text.length ? text[i] : null,
                          isActive:
                              hasFocus &&
                              widget.enabled &&
                              i == text.length &&
                              !widget.hasError &&
                              !widget.isSuccess,
                        ),
                      ],
                    ],
                  ),
                ),

                // Invisible field that owns the real input.
                Positioned.fill(
                  child: GestureDetector(
                    onLongPress: _pasteFromClipboard,
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        enabled: widget.enabled,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        enableInteractiveSelection: false,
                        showCursor: false,
                        decoration: const InputDecoration.collapsed(
                          hintText: null,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(widget.length),
                        ],
                        onChanged: _handleChanged,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBox({
    required int index,
    required double width,
    required String? digit,
    required bool isActive,
  }) {
    final isFilled = digit != null;

    // Staggered entrance: each box starts a little after the previous one.
    final start = (index * 0.1).clamp(0.0, 0.5);
    final entrance = Interval(
      start,
      start + 0.5,
      curve: Curves.easeOutCubic,
    ).transform(_entrance.value);

    // Staggered success bounce: 1 → 1.18 → 1 per box, offset by index.
    final successLocal = ((_success.value - index * 0.1) / 0.5).clamp(0.0, 1.0);
    final successScale = 1 + 0.18 * math.sin(successLocal * math.pi);

    return Opacity(
      opacity: entrance,
      child: Transform.translate(
        offset: Offset(0, (1 - entrance) * 16),
        child: Transform.scale(
          scale: successScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: width,
            height: _boxHeight,
            decoration: BoxDecoration(
              color: _fillColor(),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _borderColor(isActive, isFilled),
                width: isActive || widget.hasError || widget.isSuccess ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutBack,
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: isFilled
                  ? Text(
                      digit,
                      key: ValueKey('digit-$index-$digit'),
                      style: AppTypography.headlineMd.copyWith(
                        color: _digitColor(),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : isActive
                  ? const _BlinkingCaret(key: ValueKey('caret'))
                  : SizedBox.shrink(key: ValueKey('empty-$index')),
            ),
          ),
        ),
      ),
    );
  }
}

/// Thin vertical caret that fades in and out inside the active box.
class _BlinkingCaret extends StatefulWidget {
  const _BlinkingCaret({super.key});

  @override
  State<_BlinkingCaret> createState() => _BlinkingCaretState();
}

class _BlinkingCaretState extends State<_BlinkingCaret>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _blink,
      child: Container(
        width: 2,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A "swipe to confirm" call-to-action.
///
/// The user drags the thumb along the track; releasing past
/// [completionThreshold] completes the swipe and fires [onCompleted],
/// otherwise the thumb springs back to the start. The thumb resets itself
/// shortly after completing so it is ready again if the user navigates back.
///
/// While idle, the thumb gently nudges back and forth to hint that it can be
/// dragged (skipped when the platform has animations disabled).
///
/// While [isLoading] is true the thumb shows a spinner and dragging is
/// disabled.
///
/// For accessibility, assistive technologies see a regular button that
/// triggers [onCompleted] on activation.
class SwipeToActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onCompleted;
  final IconData icon;
  final bool isLoading;

  /// Fraction of the track (0–1) the thumb must pass to count as a swipe.
  final double completionThreshold;

  const SwipeToActionButton({
    super.key,
    required this.text,
    required this.onCompleted,
    this.icon = Icons.arrow_forward,
    this.isLoading = false,
    this.completionThreshold = 0.8,
  });

  @override
  State<SwipeToActionButton> createState() => _SwipeToActionButtonState();
}

class _SwipeToActionButtonState extends State<SwipeToActionButton>
    with TickerProviderStateMixin {
  static const double _height = 56;
  static const double _inset = 4;
  static const double _thumbSize = _height - _inset * 2;

  /// How far (in logical pixels) the idle hint nudges the thumb.
  static const double _hintDistance = 10;

  /// Thumb position as a fraction of the track: 0 = start, 1 = end.
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  /// Idle "nudge" animation, 0 → 1 → 0 on repeat.
  late final AnimationController _hint = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _completed = false;

  bool get _isIdle => !_completed && !widget.isLoading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncHint();
  }

  @override
  void didUpdateWidget(SwipeToActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) _syncHint();
  }

  @override
  void dispose() {
    _progress.dispose();
    _hint.dispose();
    super.dispose();
  }

  /// Starts the idle nudge when appropriate, otherwise eases it back to rest.
  void _syncHint() {
    final canAnimate = !MediaQuery.disableAnimationsOf(context);
    if (_isIdle && canAnimate && _progress.value == 0) {
      if (!_hint.isAnimating) _hint.repeat(reverse: true);
    } else {
      _stopHint();
    }
  }

  void _stopHint() {
    _hint.animateTo(
      0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  }

  void _onDragStart(DragStartDetails details) {
    if (!_isIdle) return;
    _stopHint();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (!_isIdle) return;
    _progress.value = (_progress.value + details.delta.dx / maxDrag).clamp(
      0.0,
      1.0,
    );
  }

  Future<void> _onDragEnd() async {
    if (!_isIdle) return;
    if (_progress.value >= widget.completionThreshold) {
      await _complete();
    } else {
      await _progress.animateTo(0, curve: Curves.easeOutCubic);
      if (mounted) _syncHint();
    }
  }

  Future<void> _complete() async {
    if (!_isIdle) return;
    _completed = true;
    _stopHint();
    HapticFeedback.mediumImpact();
    await _progress.animateTo(1, curve: Curves.easeOut);
    if (!mounted) return;
    widget.onCompleted();

    // Reset so the button works again after the user comes back.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    await _progress.animateTo(0, curve: Curves.easeOutCubic);
    if (!mounted) return;
    _completed = false;
    _syncHint();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !widget.isLoading,
      label: widget.text,
      onTap: widget.isLoading ? null : _complete,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxDrag = constraints.maxWidth - _thumbSize - _inset * 2;

            return GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxDrag),
              onHorizontalDragEnd: (_) => _onDragEnd(),
              onHorizontalDragCancel: _onDragEnd,
              child: AnimatedBuilder(
                animation: Listenable.merge([_progress, _hint]),
                builder: (context, _) {
                  final t = _progress.value;
                  final hintOffset =
                      Curves.easeInOut.transform(_hint.value) * _hintDistance;
                  final thumbLeft = _inset + t * maxDrag + hintOffset;

                  return Container(
                    height: _height,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Fill trailing behind the thumb
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: thumbLeft + _thumbSize + _inset,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer.withValues(
                                alpha: 0.25,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        // Label fades out as the thumb moves
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: _thumbSize),
                            child: Opacity(
                              opacity:
                                  (1 - t * 1.6).clamp(0.0, 1.0) *
                                  (widget.isLoading ? 0.6 : 1),
                              child: Text(
                                widget.text,
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Draggable thumb
                        Positioned(
                          left: thumbLeft,
                          child: Container(
                            width: _thumbSize,
                            height: _thumbSize,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: widget.isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(13),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryContainer,
                                    ),
                                  )
                                : Icon(
                                    t >= widget.completionThreshold
                                        ? Icons.check
                                        : widget.icon,
                                    size: 22,
                                    color: AppColors.primaryContainer,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

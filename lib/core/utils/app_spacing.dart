import 'package:flutter/widgets.dart';

/// Screen size (logical px) the spacing values in the designs were written
/// for. A typical phone is around this size.
const double _designScreenWidth = 360;
const double _designScreenHeight = 800;

/// Gap that scales with the screen size, for both directions in one place.
///
/// Replaces fixed `SizedBox` spacers:
/// ```dart
/// const SizedBox(height: 8)   →  appSpace(context, height: 8)
/// const SizedBox(width: 12)   →  appSpace(context, width: 12)
/// ```
/// [height] scales with the screen height and [width] with the screen width,
/// so a taller/wider screen gets slightly larger gaps and a smaller one gets
/// slightly smaller. Each scale is clamped to 0.8–1.25 so gaps never collapse
/// on small phones or balloon on tablets.
///
/// Uses [MediaQuery.sizeOf], so it only rebuilds when the screen size changes
/// (not when the keyboard opens).
SizedBox appSpace(BuildContext context, {double? width, double? height}) {
  final size = MediaQuery.sizeOf(context);
  return SizedBox(
    width: width == null
        ? null
        : width * (size.width / _designScreenWidth).clamp(0.8, 1.25),
    height: height == null
        ? null
        : height * (size.height / _designScreenHeight).clamp(0.8, 1.25),
  );
}

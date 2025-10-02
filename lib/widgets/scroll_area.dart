
import 'package:flutter/material.dart';

/// A custom scrollable area with stylized scrollbars.
class ScrollArea extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final bool showScrollbar;

  const ScrollArea({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.showScrollbar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scrollable = SingleChildScrollView(
      scrollDirection: scrollDirection,
      child: child,
    );

    if (!showScrollbar) return scrollable;

    return ScrollConfiguration(
      behavior: _NoGlowScrollBehavior(),
      child: RawScrollbar(
        thumbColor: Colors.grey.shade400,
        radius: const Radius.circular(10),
        thickness: 6,
        trackVisibility: true,
        child: scrollable,
      ),
    );
  }
}

/// Remove the default overscroll glow effect
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


```dart
import 'package:flutter/material.dart';

/// TooltipProvider equivalent – handles global defaults.
/// Like Radix Provider with delayDuration
class TooltipProvider extends InheritedWidget {
  final int delayDuration; // in milliseconds

  const TooltipProvider({
    Key? key,
    required Widget child,
    this.delayDuration = 0,
  }) : super(key: key, child: child);

  static TooltipProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TooltipProvider>();
  }

  @override
  bool updateShouldNotify(TooltipProvider oldWidget) {
    return delayDuration != oldWidget.delayDuration;
  }
}

/// Tooltip Root + Content + Trigger combined
class AppTooltip extends StatelessWidget {
  final Widget trigger;
  final String message;
  final int? delayDuration;
  final TooltipDirection side;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool showArrow;

  const AppTooltip({
    Key? key,
    required this.trigger,
    required this.message,
    this.delayDuration,
    this.side = TooltipDirection.top,
    this.textStyle,
    this.backgroundColor,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedDelay =
        TooltipProvider.of(context)?.delayDuration ?? 0;

    return _TooltipWithArrow(
      trigger: trigger,
      message: message,
      waitDuration: Duration(milliseconds: delayDuration ?? inheritedDelay),
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.primary,
      textStyle: textStyle ??
          TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12,
          ),
      side: side,
      showArrow: showArrow,
    );
  }
}

/// Internal widget for Tooltip + Arrow
class _TooltipWithArrow extends StatefulWidget {
  final Widget trigger;
  final String message;
  final Duration waitDuration;
  final TextStyle textStyle;
  final Color backgroundColor;
  final TooltipDirection side;
  final bool showArrow;

  const _TooltipWithArrow({
    required this.trigger,
    required this.message,
    required this.waitDuration,
    required this.textStyle,
    required this.backgroundColor,
    required this.side,
    required this.showArrow,
  });

  @override
  State<_TooltipWithArrow> createState() => _TooltipWithArrowState();
}

class _TooltipWithArrowState extends State<_TooltipWithArrow> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  void _showTooltip() {
    if (_isVisible) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: widget.side == TooltipDirection.top
            ? offset.dy - 40
            : offset.dy + size.height + 8,
        child: CompositedTransformFollower(
          link: _layerLink,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.side == TooltipDirection.bottom &&
                    widget.showArrow)
                  _Arrow(color: widget.backgroundColor),
                Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(widget.message, style: widget.textStyle),
                ),
                if (widget.side == TooltipDirection.top && widget.showArrow)
                  _Arrow(color: widget.backgroundColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTapDown: (_) {
          Future.delayed(widget.waitDuration, _showTooltip);
        },
        onTapUp: (_) => _hideTooltip(),
        onTapCancel: _hideTooltip,
        child: widget.trigger,
      ),
    );
  }
}

/// Custom Arrow like Radix Tooltip.Arrow
class _Arrow extends StatelessWidget {
  final Color color;

  const _Arrow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 45 * 3.14159 / 180,
      child: Container(
        width: 10,
        height: 10,
        color: color,
      ),
    );
  }
}

/// Simple enum for tooltip positioning
enum TooltipDirection { top, bottom }
```

---

### 📂 Where to put this in your Flutter project

* Create folder if not present:

  ```
  lib/widgets/
  ```
* Save the code as:

  ```
  lib/widgets/tooltip.dart
  ```

---

### ✅ How to use

```dart
import 'package:your_app/widgets/tooltip.dart';

TooltipProvider(
  delayDuration: 500, // like Radix delayDuration
  child: Center(
    child: AppTooltip(
      message: "This is a tooltip with arrow",
      trigger: Icon(Icons.info_outline),
      side: TooltipDirection.bottom,
      showArrow: true,
    ),
  ),
);
```


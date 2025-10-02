
import 'package:flutter/material.dart';

enum ToastTheme { light, dark, system }

class CustomToaster extends StatefulWidget {
  final ToastTheme theme;
  final Duration duration;
  final Widget? child; // optional content
  final EdgeInsets margin;

  const CustomToaster({
    super.key,
    this.theme = ToastTheme.system,
    this.duration = const Duration(seconds: 3),
    this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
  });

  @override
  State<CustomToaster> createState() => _CustomToasterState();
}

class _CustomToasterState extends State<CustomToaster> {
  final List<OverlayEntry> _toasts = [];

  void showToast(Widget content) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: widget.margin.top,
        right: widget.margin.right,
        left: widget.margin.left,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: 1.0,
            child: _ThemedToast(
              theme: widget.theme,
              child: content,
            ),
          ),
        ),
      ),
    );

    _toasts.add(entry);
    overlay.insert(entry);

    Future.delayed(widget.duration, () {
      entry.remove();
      _toasts.remove(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}

class _ThemedToast extends StatelessWidget {
  final ToastTheme theme;
  final Widget child;

  const _ThemedToast({required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine theme colors
    final brightness = theme == ToastTheme.system
        ? MediaQuery.of(context).platformBrightness
        : (theme == ToastTheme.dark ? Brightness.dark : Brightness.light);

    final backgroundColor = brightness == Brightness.dark
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface;

    final textColor = brightness == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.surface;

    final borderColor = Theme.of(context).dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black26,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: child,
      ),
    );
  }
}


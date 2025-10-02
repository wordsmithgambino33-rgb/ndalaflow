
import 'package:flutter/material.dart';

enum AlertVariant { defaultVariant, destructive }

class _AlertContext extends InheritedWidget {
  final AlertVariant variant;

  const _AlertContext({
    required this.variant,
    required super.child,
  });

  static _AlertContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AlertContext>();
  }

  @override
  bool updateShouldNotify(_AlertContext oldWidget) {
    return variant != oldWidget.variant;
  }
}

class Alert extends StatelessWidget {
  final AlertVariant variant;
  final Widget? leading;
  final List<Widget> children;

  const Alert({
    super.key,
    this.variant = AlertVariant.defaultVariant,
    this.leading,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = colorScheme.surface;
    final borderColor = colorScheme.outline;
    final iconColor = variant == AlertVariant.destructive ? colorScheme.error : colorScheme.onSurface;

    return _AlertContext(
      variant: variant,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: IconTheme(
                  data: IconThemeData(color: iconColor, size: 16),
                  child: leading!,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children
                    .map(
                      (child) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: child,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertTitle extends StatelessWidget {
  final Widget child;

  const AlertTitle({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final variant = _AlertContext.of(context)?.variant ?? AlertVariant.defaultVariant;
    final colorScheme = Theme.of(context).colorScheme;
    final color = variant == AlertVariant.destructive ? colorScheme.error : colorScheme.onSurface;

    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.25,
      ),
      child: SizedBox(
        height: 16, // min-h-4 equivalent
        child: child,
      ),
    );
  }
}

class AlertDescription extends StatelessWidget {
  final Widget child;

  const AlertDescription({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final variant = _AlertContext.of(context)?.variant ?? AlertVariant.defaultVariant;
    final colorScheme = Theme.of(context).colorScheme;
    var color = colorScheme.onSurfaceVariant;
    if (variant == AlertVariant.destructive) {
      color = colorScheme.error.withOpacity(0.9);
    }

    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: 14,
        height: 1.5, // leading-relaxed
      ),
      child: child,
    );
  }
}
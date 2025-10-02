
import 'package:flutter/material.dart';

enum BadgeVariant { defaultVariant, secondary, destructive, outline }

class CustomBadge extends StatelessWidget {
  final BadgeVariant variant;
  final Widget child;
  final VoidCallback? onTap;

  const CustomBadge({
    super.key,
    this.variant = BadgeVariant.defaultVariant,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color? backgroundColor;
    Color? foregroundColor;
    Color? borderColor;

    switch (variant) {
      case BadgeVariant.defaultVariant:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.secondary:
        backgroundColor = colorScheme.surfaceVariant;
        foregroundColor = colorScheme.onSurface;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        borderColor = colorScheme.outline;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foregroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: foregroundColor,
              size: 12,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

enum ButtonVariant { defaultVariant, destructive, outline, secondary, ghost, link }

enum ButtonSize { defaultSize, sm, lg, icon }

class CustomButton extends StatelessWidget {
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool isInvalid; // For aria-invalid equivalent

  const CustomButton({
    Key? key,
    this.variant = ButtonVariant.defaultVariant,
    this.size = ButtonSize.defaultSize,
    this.onPressed,
    this.child,
    this.isInvalid = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isEnabled = onPressed != null;
    final double opacity = isEnabled ? 1.0 : 0.5;

    // Base style
    final baseStyle = ButtonStyle(
      padding: MaterialStateProperty.all(_getPadding()),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      minimumSize: MaterialStateProperty.all(_getMinimumSize()),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      overlayColor: MaterialStateProperty.all(colorScheme.primary.withOpacity(0.1)), // Ripple
    );

    switch (variant) {
      case ButtonVariant.defaultVariant:
        return Opacity(
          opacity: opacity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(colorScheme.primary),
              foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
            ),
            child: child,
          ),
        );
      case ButtonVariant.destructive:
        return Opacity(
          opacity: opacity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(colorScheme.error),
              foregroundColor: MaterialStateProperty.all(colorScheme.onError),
              side: isInvalid ? MaterialStateProperty.all(BorderSide(color: colorScheme.error)) : null,
            ),
            child: child,
          ),
        );
      case ButtonVariant.outline:
        return Opacity(
          opacity: opacity,
          child: OutlinedButton(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(colorScheme.surface),
              foregroundColor: MaterialStateProperty.all(colorScheme.onSurface),
              side: MaterialStateProperty.all(BorderSide(color: colorScheme.outline)),
            ),
            child: child,
          ),
        );
      case ButtonVariant.secondary:
        return Opacity(
          opacity: opacity,
          child: FilledButton.tonal(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(colorScheme.secondaryContainer),
              foregroundColor: MaterialStateProperty.all(colorScheme.onSecondaryContainer),
            ),
            child: child,
          ),
        );
      case ButtonVariant.ghost:
        return Opacity(
          opacity: opacity,
          child: TextButton(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(colorScheme.onSurface),
            ),
            child: child,
          ),
        );
      case ButtonVariant.link:
        return Opacity(
          opacity: opacity,
          child: TextButton(
            onPressed: onPressed,
            style: baseStyle.copyWith(
              foregroundColor: MaterialStateProperty.all(colorScheme.primary),
              textStyle: MaterialStateProperty.all(const TextStyle(decoration: TextDecoration.underline)),
            ),
            child: child,
          ),
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 8);
      case ButtonSize.icon:
        return const EdgeInsets.all(8);
      case ButtonSize.defaultSize:
      default:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case ButtonSize.sm:
        return const Size(0, 32);
      case ButtonSize.lg:
        return const Size(0, 40);
      case ButtonSize.icon:
        return const Size(36, 36);
      case ButtonSize.defaultSize:
      default:
        return const Size(0, 36);
    }
  }
}
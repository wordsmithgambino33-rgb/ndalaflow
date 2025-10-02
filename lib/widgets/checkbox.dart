
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool isDisabled;
  final String? label;
  final double size;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
    this.label,
    this.size = 24.0,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.backgroundColor,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;
    final effectiveBorderColor = borderColor ?? Colors.grey.shade400;
    final effectiveBackgroundColor = backgroundColor ?? Colors.white;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (onChanged != null) {
                onChanged!(!value);
              }
            },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: Checkbox(
                value: value,
                onChanged: isDisabled ? null : onChanged,
                activeColor: effectiveActiveColor,
                checkColor: checkColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: value ? effectiveActiveColor : effectiveBorderColor,
                  width: 2,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label!,
                  style: labelStyle ??
                      TextStyle(
                        color: isDisabled
                            ? Colors.grey.shade400
                            : Colors.black87,
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

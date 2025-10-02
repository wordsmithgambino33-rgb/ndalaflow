
import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final bool isDisabled;
  final TextStyle? style;

  const CustomLabel({
    Key? key,
    required this.text,
    this.isDisabled = false,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
            color: isDisabled
                ? Colors.grey.shade400
                : style?.color ?? Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: FontWeight.w500,
          ) ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDisabled ? Colors.grey.shade400 : Colors.black,
          ),
    );
  }
}

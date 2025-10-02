
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final bool isDisabled;
  final TextInputType? keyboardType;
  final bool isError;
  final void Function(String)? onChanged;
  final String? initialValue;

  const CustomInput({
    Key? key,
    this.controller,
    this.placeholder,
    this.isDisabled = false,
    this.keyboardType,
    this.isError = false,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller ?? TextEditingController(text: initialValue),
      keyboardType: keyboardType,
      enabled: !isDisabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: isDisabled
            ? Colors.grey.shade200
            : Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isError
                ? Colors.red
                : Theme.of(context).inputDecorationTheme.border?.borderSide.color ??
                    Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isError ? Colors.red : Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}

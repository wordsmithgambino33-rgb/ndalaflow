
import 'package:flutter/material.dart';

/// Custom Radio Group Widget
class RadioGroup<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?> onChanged;
  final List<RadioOption<T>> options;
  final Axis direction;
  final double spacing;

  const RadioGroup({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.direction = Axis.vertical,
    this.spacing = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options
                .map((option) => Padding(
                      padding: EdgeInsets.only(bottom: spacing),
                      child: RadioListTile<T>(
                        value: option.value,
                        groupValue: value,
                        onChanged: onChanged,
                        title: option.label,
                        activeColor: option.activeColor ?? Theme.of(context).primaryColor,
                      ),
                    ))
                .toList(),
          )
        : Row(
            children: options
                .map((option) => Padding(
                      padding: EdgeInsets.only(right: spacing),
                      child: _CustomRadioItem<T>(
                        value: option.value,
                        groupValue: value,
                        onChanged: onChanged,
                        label: option.label,
                        activeColor: option.activeColor,
                      ),
                    ))
                .toList(),
          );
  }
}

/// Represents a single option in the radio group
class RadioOption<T> {
  final T value;
  final Widget label;
  final Color? activeColor;

  RadioOption({
    required this.value,
    required this.label,
    this.activeColor,
  });
}

/// Custom horizontal radio item
class _CustomRadioItem<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Widget label;
  final Color? activeColor;

  const _CustomRadioItem({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.activeColor,
  }) : super(key: key);

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isSelected ? (activeColor ?? Theme.of(context).primaryColor) : Colors.grey,
                width: 2,
              ),
            ),
            child: _isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor ?? Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          label,
        ],
      ),
    );
  }
}

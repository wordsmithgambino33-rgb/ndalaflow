
import 'package:flutter/material.dart';

/// Fully featured dropdown select component with groups, labels, scroll buttons, and separators.
class CustomSelect<T> extends StatefulWidget {
  final List<CustomSelectItem<T>> items;
  final T? value;
  final String? placeholder;
  final void Function(T?)? onChanged;
  final double? maxHeight;

  const CustomSelect({
    Key? key,
    required this.items,
    this.value,
    this.placeholder,
    this.onChanged,
    this.maxHeight,
  }) : super(key: key);

  @override
  State<CustomSelect<T>> createState() => _CustomSelectState<T>();
}

class _CustomSelectState<T> extends State<CustomSelect<T>> {
  late T? selectedValue;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
        color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedValue,
          hint: widget.placeholder != null ? Text(widget.placeholder!) : null,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20),
          items: _buildDropdownItems(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            if (widget.onChanged != null) widget.onChanged!(value);
          },
          dropdownColor: Theme.of(context).cardColor,
          menuMaxHeight: widget.maxHeight ?? 250,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>> _buildDropdownItems() {
    List<DropdownMenuItem<T>> menuItems = [];

    for (var item in widget.items) {
      if (item.isSeparator) {
        menuItems.add(
          DropdownMenuItem<T>(
            enabled: false,
            child: Divider(height: 1, color: Colors.grey.shade400),
          ),
        );
        continue;
      }

      if (item.isLabel) {
        menuItems.add(
          DropdownMenuItem<T>(
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
        continue;
      }

      menuItems.add(
        DropdownMenuItem<T>(
          value: item.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label),
              if (selectedValue == item.value)
                const Icon(Icons.check, size: 20, color: Colors.blue),
            ],
          ),
        ),
      );
    }

    return menuItems;
  }
}

/// Represents an item in the select dropdown
class CustomSelectItem<T> {
  final T? value;
  final String label;
  final bool isSeparator;
  final bool isLabel;

  CustomSelectItem({
    this.value,
    required this.label,
    this.isSeparator = false,
    this.isLabel = false,
  });
}


```dart
import 'package:flutter/material.dart';

/// Variants for toggle styling
enum ToggleVariant { normal, outline }

/// Sizes for toggle items
enum ToggleSize { small, medium, large }

class ToggleGroup extends StatefulWidget {
  final List<Widget> children; // supports icons, text, or any widget
  final List<int> selectedIndexes;
  final Function(List<int>) onChanged;
  final ToggleVariant variant;
  final ToggleSize size;
  final bool multiple; // whether multiple items can be selected

  const ToggleGroup({
    super.key,
    required this.children,
    required this.onChanged,
    this.selectedIndexes = const [],
    this.variant = ToggleVariant.normal,
    this.size = ToggleSize.medium,
    this.multiple = false,
  });

  @override
  State<ToggleGroup> createState() => _ToggleGroupState();
}

class _ToggleGroupState extends State<ToggleGroup> {
  late List<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedIndexes);
  }

  void _onItemTap(int index) {
    setState(() {
      if (widget.multiple) {
        if (_selected.contains(index)) {
          _selected.remove(index);
        } else {
          _selected.add(index);
        }
      } else {
        _selected = [index];
      }
      widget.onChanged(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (index) {
        final isSelected = _selected.contains(index);
        return ToggleGroupItem(
          child: widget.children[index],
          selected: isSelected,
          onTap: () => _onItemTap(index),
          variant: widget.variant,
          size: widget.size,
          isFirst: index == 0,
          isLast: index == widget.children.length - 1,
        );
      }),
    );
  }
}

class ToggleGroupItem extends StatefulWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  final ToggleVariant variant;
  final ToggleSize size;
  final bool isFirst;
  final bool isLast;

  const ToggleGroupItem({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
    this.variant = ToggleVariant.normal,
    this.size = ToggleSize.medium,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<ToggleGroupItem> createState() => _ToggleGroupItemState();
}

class _ToggleGroupItemState extends State<ToggleGroupItem> {
  bool _hovering = false;
  bool _focused = false;

  double get _height {
    switch (widget.size) {
      case ToggleSize.small:
        return 32;
      case ToggleSize.medium:
        return 40;
      case ToggleSize.large:
        return 48;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case ToggleSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case ToggleSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ToggleSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  BorderRadius get _radius {
    if (widget.isFirst) {
      return const BorderRadius.only(
        topLeft: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      );
    } else if (widget.isLast) {
      return const BorderRadius.only(
        topRight: Radius.circular(6),
        bottomRight: Radius.circular(6),
      );
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderColor = widget.variant == ToggleVariant.outline
        ? theme.dividerColor
        : Colors.transparent;

    final bgColor = widget.selected
        ? theme.colorScheme.primary.withOpacity(0.15)
        : _hovering
            ? theme.hoverColor
            : theme.colorScheme.surface;

    final textColor = widget.selected
        ? theme.colorScheme.primary
        : theme.textTheme.bodyMedium?.color;

    final focusBorder = _focused
        ? Border.all(color: theme.colorScheme.primary, width: 2)
        : Border.all(color: borderColor, width: 1);

    return FocusableActionDetector(
      onShowFocusHighlight: (focus) {
        setState(() => _focused = focus);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: _height,
            padding: _padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              border: focusBorder.borderSide == BorderSide.none
                  ? null
                  : Border.fromBorderSide(focusBorder.borderSide),
              borderRadius: _radius,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: textColor,
                  size: 18,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Example usage

```dart
ToggleGroup(
  children: const [
    Icon(Icons.format_bold),
    Icon(Icons.format_italic),
    Icon(Icons.format_underlined),
    Text("ABC"), // supports any widget, like React
  ],
  multiple: true,
  selectedIndexes: [0, 3],
  variant: ToggleVariant.outline,
  size: ToggleSize.medium,
  onChanged: (selected) {
    print("Selected indexes: $selected");
  },
)
```

---




```dart
import 'package:flutter/material.dart';

/// ToggleVariants replicates the React cva-based styling system
/// by providing size and variant options.
enum ToggleVariant { `default`, outline }
enum ToggleSize { sm, md, lg }

class Toggle extends StatefulWidget {
  final bool initialValue;
  final ToggleVariant variant;
  final ToggleSize size;
  final ValueChanged<bool>? onChanged;
  final Widget? icon;
  final String? label;

  const Toggle({
    Key? key,
    this.initialValue = false,
    this.variant = ToggleVariant.default,
    this.size = ToggleSize.md,
    this.onChanged,
    this.icon,
    this.label,
  }) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    // Map size to padding and height
    final Map<ToggleSize, EdgeInsets> paddings = {
      ToggleSize.sm: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ToggleSize.md: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ToggleSize.lg: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    };

    final Map<ToggleSize, double> heights = {
      ToggleSize.sm: 32,
      ToggleSize.md: 36,
      ToggleSize.lg: 40,
    };

    // Colors (you can theme these)
    final Color accentColor = Theme.of(context).colorScheme.primary;
    final Color accentForeground = Theme.of(context).colorScheme.onPrimary;
    final Color muted = Theme.of(context).colorScheme.surfaceVariant;
    final Color mutedForeground = Theme.of(context).colorScheme.onSurfaceVariant;

    // Base styling
    BoxDecoration decoration;
    if (_isOn) {
      decoration = BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(8),
      );
    } else {
      if (widget.variant == ToggleVariant.outline) {
        decoration = BoxDecoration(
          border: Border.all(color: mutedForeground),
          borderRadius: BorderRadius.circular(8),
        );
      } else {
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        );
      }
    }

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: heights[widget.size],
        padding: paddings[widget.size],
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  size: 16,
                  color: _isOn ? accentForeground : mutedForeground,
                ),
                child: widget.icon!,
              ),
              if (widget.label != null) const SizedBox(width: 4),
            ],
            if (widget.label != null)
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _isOn ? accentForeground : mutedForeground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 📂 Where to put this in your Flutter project

* Create a folder for shared UI components if not already present:

  ```
  lib/widgets/
  ```
* Save the code in a new file:

  ```
  lib/widgets/toggle.dart
  ```

### ✅ How to use in Flutter:

```dart
import 'package:your_app/widgets/toggle.dart';

Toggle(
  initialValue: false,
  variant: ToggleVariant.outline,
  size: ToggleSize.md,
  icon: const Icon(Icons.star),
  label: "Favorite",
  onChanged: (value) {
    print("Toggle is now: $value");
  },
),
```



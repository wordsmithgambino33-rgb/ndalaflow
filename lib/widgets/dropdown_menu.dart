
import 'package:flutter/material.dart';

/// -----------------------------
/// DROPDOWN MENU ROOT
/// -----------------------------
class DropdownMenu extends StatefulWidget {
  final Widget trigger;
  final List<Widget> children;

  const DropdownMenu({super.key, required this.trigger, required this.children});

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _overlayEntry?.remove();
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: 200, // default width
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: widget.trigger,
      ),
    );
  }
}

/// -----------------------------
/// DROPDOWN MENU ITEM
/// -----------------------------
class DropdownMenuItemWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool destructive;
  final bool inset;

  const DropdownMenuItemWidget({
    super.key,
    required this.child,
    this.onTap,
    this.destructive = false,
    this.inset = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(inset ? 16 : 8, 8, 8, 8),
        color: Colors.transparent,
        child: DefaultTextStyle(
          style: TextStyle(
            color: destructive ? Colors.red : Colors.black,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// -----------------------------
/// DROPDOWN MENU CHECKBOX ITEM
/// -----------------------------
class DropdownMenuCheckboxItemWidget extends StatelessWidget {
  final Widget child;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  const DropdownMenuCheckboxItemWidget({
    super.key,
    required this.child,
    this.checked = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!checked),
      child: Row(
        children: [
          Checkbox(value: checked, onChanged: onChanged),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// -----------------------------
/// DROPDOWN MENU RADIO GROUP & ITEM
/// -----------------------------
class DropdownMenuRadioGroup<T> extends StatelessWidget {
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final List<DropdownMenuRadioItem<T>> items;

  const DropdownMenuRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return RadioListTile<T>(
          value: item.value,
          groupValue: groupValue,
          onChanged: onChanged,
          title: item.child,
        );
      }).toList(),
    );
  }
}

class DropdownMenuRadioItem<T> {
  final T value;
  final Widget child;
  DropdownMenuRadioItem({required this.value, required this.child});
}

/// -----------------------------
/// DROPDOWN MENU LABEL
/// -----------------------------
class DropdownMenuLabelWidget extends StatelessWidget {
  final String label;
  final bool inset;

  const DropdownMenuLabelWidget({super.key, required this.label, this.inset = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(inset ? 16 : 8, 8, 8, 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

/// -----------------------------
/// DROPDOWN MENU SEPARATOR
/// -----------------------------
class DropdownMenuSeparatorWidget extends StatelessWidget {
  const DropdownMenuSeparatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Colors.grey);
  }
}

/// -----------------------------
/// DROPDOWN MENU SHORTCUT
/// -----------------------------
class DropdownMenuShortcutWidget extends StatelessWidget {
  final String shortcut;

  const DropdownMenuShortcutWidget({super.key, required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return Text(
      shortcut,
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }
}

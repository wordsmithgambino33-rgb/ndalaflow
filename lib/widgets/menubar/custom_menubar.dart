
import 'package:flutter/material.dart';

/// Utility function for conditional class-like styling
TextStyle mergeTextStyle(TextStyle base, TextStyle? other) =>
    other != null ? base.merge(other) : base;

/// Menubar Root
class Menubar extends StatelessWidget {
  final List<Widget> children;

  const Menubar({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// Menubar Menu
class MenubarMenu extends StatelessWidget {
  final Widget trigger;
  final List<Widget> items;

  const MenubarMenu({Key? key, required this.trigger, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenubarSub(
      trigger: trigger,
      content: MenubarContent(children: items),
    );
  }
}

/// Menubar Group (just a wrapper)
class MenubarGroup extends StatelessWidget {
  final List<Widget> children;
  const MenubarGroup({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(children: children);
}

/// Menubar Content
class MenubarContent extends StatelessWidget {
  final List<Widget> children;
  const MenubarContent({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(6),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Menubar Item
class MenubarItem extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final bool destructive;
  final VoidCallback? onPressed;

  const MenubarItem({
    Key? key,
    required this.child,
    this.disabled = false,
    this.destructive = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = destructive ? Colors.red : Colors.black;
    return InkWell(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: DefaultTextStyle(
          style: TextStyle(color: textColor),
          child: child,
        ),
      ),
    );
  }
}

/// Menubar Checkbox Item
class MenubarCheckboxItem extends StatefulWidget {
  final Widget child;
  final bool initialChecked;
  final ValueChanged<bool>? onChanged;

  const MenubarCheckboxItem({
    Key? key,
    required this.child,
    this.initialChecked = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MenubarCheckboxItem> createState() => _MenubarCheckboxItemState();
}

class _MenubarCheckboxItemState extends State<MenubarCheckboxItem> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.initialChecked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          checked = !checked;
        });
        widget.onChanged?.call(checked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Checkbox(value: checked, onChanged: (val) {}),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

/// Menubar Radio Group
class MenubarRadioGroup<T> extends StatefulWidget {
  final T value;
  final ValueChanged<T> onChanged;
  final List<MenubarRadioItem<T>> items;

  const MenubarRadioGroup({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  State<MenubarRadioGroup<T>> createState() => _MenubarRadioGroupState<T>();
}

class _MenubarRadioGroupState<T> extends State<MenubarRadioGroup<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedValue = item.value;
            });
            widget.onChanged(selectedValue);
          },
          child: Row(
            children: [
              Radio<T>(
                value: item.value,
                groupValue: selectedValue,
                onChanged: (_) {},
              ),
              Expanded(child: item.child),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class MenubarRadioItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const MenubarRadioItem({Key? key, required this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}

/// Menubar Submenu
class MenubarSub extends StatefulWidget {
  final Widget trigger;
  final MenubarContent content;

  const MenubarSub({Key? key, required this.trigger, required this.content})
      : super(key: key);

  @override
  State<MenubarSub> createState() => _MenubarSubState();
}

class _MenubarSubState extends State<MenubarSub>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  late AnimationController controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  void showMenu() {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Material(
            child: widget.content,
          ),
        ),
      ),
    );
    Overlay.of(context)?.insert(overlayEntry!);
    controller.forward();
  }

  void hideMenu() {
    controller.reverse().then((_) {
      overlayEntry?.remove();
      overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (overlayEntry == null) {
          showMenu();
        } else {
          hideMenu();
        }
      },
      child: widget.trigger,
    );
  }
}

/// Menubar Label
class MenubarLabel extends StatelessWidget {
  final String text;
  const MenubarLabel({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

/// Menubar Separator
class MenubarSeparator extends StatelessWidget {
  const MenubarSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
}

/// Menubar Shortcut
class MenubarShortcut extends StatelessWidget {
  final String text;
  const MenubarShortcut({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontSize: 10, color: Colors.grey.shade600));
  }
}

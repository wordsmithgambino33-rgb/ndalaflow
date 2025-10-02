
import 'package:flutter/material.dart';

/// Root context menu wrapper
class ContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuEntry> entries;

  const ContextMenu({super.key, required this.child, required this.entries});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = RelativeRect.fromRect(
          details.globalPosition & const Size(40, 40),
          Offset.zero & overlay.size,
        );
        showMenu(
          context: context,
          position: position,
          items: entries.map((e) => e.toPopupMenuEntry(context)).toList(),
        );
      },
      child: child,
    );
  }
}

/// Base class for context menu items
abstract class ContextMenuEntry {
  PopupMenuEntry toPopupMenuEntry(BuildContext context);
}

/// Standard clickable item
class ContextMenuItem extends ContextMenuEntry {
  final String label;
  final VoidCallback? onTap;
  final bool destructive;
  final bool inset;

  ContextMenuItem({
    required this.label,
    this.onTap,
    this.destructive = false,
    this.inset = false,
  });

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: inset ? 16.0 : 0),
        child: Text(
          label,
          style: TextStyle(
            color: destructive ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

/// Checkbox item
class ContextMenuCheckboxItem extends ContextMenuEntry {
  final String label;
  final bool checked;
  final ValueChanged<bool?>? onChanged;

  ContextMenuCheckboxItem({
    required this.label,
    required this.checked,
    this.onChanged,
  });

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      enabled: false,
      child: StatefulBuilder(
        builder: (context, setState) => CheckboxListTile(
          value: checked,
          title: Text(label),
          onChanged: (value) {
            setState(() {});
            onChanged?.call(value);
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}

/// Radio item
class ContextMenuRadioItem<T> extends ContextMenuEntry {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;

  ContextMenuRadioItem({
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      enabled: false,
      child: StatefulBuilder(
        builder: (context, setState) => RadioListTile<T>(
          value: value,
          groupValue: groupValue,
          title: Text(label),
          onChanged: (val) {
            setState(() {});
            onChanged?.call(val);
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}

/// Non-clickable label
class ContextMenuLabel extends ContextMenuEntry {
  final String label;
  final bool inset;

  ContextMenuLabel({required this.label, this.inset = false});

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      enabled: false,
      child: Padding(
        padding: EdgeInsets.only(left: inset ? 16 : 0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Separator
class ContextMenuSeparator extends ContextMenuEntry {
  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return const PopupMenuDivider(height: 1);
  }
}

/// Shortcut text
class ContextMenuShortcut extends StatelessWidget {
  final String text;

  const ContextMenuShortcut({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

/// Submenu
class ContextMenuSub extends ContextMenuEntry {
  final String label;
  final List<ContextMenuEntry> children;
  final bool inset;

  ContextMenuSub({
    required this.label,
    required this.children,
    this.inset = false,
  });

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      enabled: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            contentPadding: EdgeInsets.only(left: inset ? 16 : 0),
            title: Text(label),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final position = RelativeRect.fromLTRB(100, 100, 0, 0);
              showMenu(
                context: context,
                position: position,
                items: children.map((e) => e.toPopupMenuEntry(context)).toList(),
              );
            },
          );
        },
      ),
    );
  }
}

/// Context menu group
class ContextMenuGroup extends ContextMenuEntry {
  final List<ContextMenuEntry> entries;

  ContextMenuGroup({required this.entries});

  @override
  PopupMenuItem toPopupMenuEntry(BuildContext context) {
    return PopupMenuItem(
      enabled: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries.map((e) => e.toPopupMenuEntry(context)).toList(),
      ),
    );
  }
}

/// Portal (Overlay wrapper)
class ContextMenuPortal extends StatelessWidget {
  final Widget child;

  const ContextMenuPortal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]);
  }
}

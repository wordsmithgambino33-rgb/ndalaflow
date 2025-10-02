
import 'package:flutter/material.dart';

/// Command root widget
class Command extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const Command({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      padding: padding ?? EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

/// Command dialog
class CommandDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const CommandDialog({
    Key? key,
    this.title = "Command Palette",
    this.description = "Search for a command to run...",
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: title,
            hint: description,
            child: SizedBox.shrink(),
          ),
          child,
        ],
      ),
    );
  }
}

/// Command input with search icon
class CommandInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Function(String)? onChanged;

  const CommandInput({
    Key? key,
    this.controller,
    this.placeholder,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: Colors.grey.shade500),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: placeholder ?? "Search...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Command list container
class CommandList extends StatelessWidget {
  final List<Widget> children;
  final double? maxHeight;

  const CommandList({Key? key, required this.children, this.maxHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight ?? 300),
      child: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );
  }
}

/// Empty state
class CommandEmpty extends StatelessWidget {
  final String message;

  const CommandEmpty({Key? key, this.message = "No results."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
      ),
    );
  }
}

/// Command group
class CommandGroup extends StatelessWidget {
  final String? heading;
  final List<Widget> children;

  const CommandGroup({Key? key, this.heading, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              heading!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}

/// Command item
class CommandItem extends StatelessWidget {
  final String label;
  final bool selected;
  final bool disabled;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CommandItem({
    Key? key,
    required this.label,
    this.selected = false,
    this.disabled = false,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
        child: Row(
          children: [
            if (leading != null) leading!,
            if (leading != null) SizedBox(width: 8),
            Expanded(child: Text(label)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// Command shortcut
class CommandShortcut extends StatelessWidget {
  final String text;

  const CommandShortcut({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// Separator
class CommandSeparator extends StatelessWidget {
  const CommandSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
}

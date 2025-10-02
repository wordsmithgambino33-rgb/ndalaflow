import 'package:flutter/material.dart';

/// Root Dialog wrapper
class AppDialog extends StatelessWidget {
  final Widget child;
  final bool isOpen;
  final VoidCallback? onClose;

  const AppDialog({
    super.key,
    required this.child,
    required this.isOpen,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        // Overlay background
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black54,
          ),
        ),
        // Centered dialog
        Center(
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Dialog Header with optional title and description
class DialogHeader extends StatelessWidget {
  final Widget? title;
  final Widget? description;
  final bool hideForScreenReaders;

  const DialogHeader({
    super.key,
    this.title,
    this.description,
    this.hideForScreenReaders = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hideForScreenReaders) {
      return Semantics(
        container: true,
        child: Column(
          children: [],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) title!,
        if (description != null) description!,
      ],
    );
  }
}

/// Dialog Title
class DialogTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const DialogTitle({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Dialog Description
class DialogDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const DialogDescription({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: style ?? const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}

/// Dialog Content wrapper
class DialogContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double maxWidth;
  final double maxHeight;

  const DialogContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = 400,
    this.maxHeight = 600,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).dialogBackgroundColor,
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}

/// Dialog Close Button
class DialogCloseButton extends StatelessWidget {
  final VoidCallback? onClose;
  final Icon? icon;

  const DialogCloseButton({super.key, this.onClose, this.icon});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: icon ?? const Icon(Icons.close),
        onPressed: onClose ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
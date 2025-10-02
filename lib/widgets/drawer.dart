
import 'package:flutter/material.dart';

/// Drawer Root
class AppDrawer extends StatelessWidget {
  final Widget child;
  final double width;
  final bool isOpen;
  final VoidCallback onClose;

  const AppDrawer({
    Key? key,
    required this.child,
    this.width = 300,
    required this.isOpen,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isOpen)
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: isOpen ? 0 : -width,
          top: 0,
          bottom: 0,
          child: Material(
            elevation: 16,
            child: Container(
              width: width,
              color: Theme.of(context).colorScheme.surface,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

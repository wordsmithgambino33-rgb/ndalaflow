
import 'package:flutter/material.dart';

/// Popover root
class Popover extends StatefulWidget {
  final Widget child; // Trigger button or anchor
  final Widget content; // Popover content
  final Alignment alignment; // Align content relative to trigger
  final double sideOffset; // Space between trigger and content

  const Popover({
    Key? key,
    required this.child,
    required this.content,
    this.alignment = Alignment.center,
    this.sideOffset = 4.0,
  }) : super(key: key);

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showPopover() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + widget.sideOffset,
        width: 300, // You can make this flexible
        child: Material(
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + widget.sideOffset),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.content,
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
        onTap: () {
          if (_overlayEntry == null) {
            _showPopover();
          } else {
            _hidePopover();
          }
        },
        child: widget.child,
      ),
    );
  }
}

/// Optional anchor widget (for positioning only)
class PopoverAnchor extends StatelessWidget {
  final Widget child;

  const PopoverAnchor({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Popover trigger button (can be any widget)
class PopoverTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const PopoverTrigger({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}

/// Popover content container
class PopoverContent extends StatelessWidget {
  final Widget child;

  const PopoverContent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

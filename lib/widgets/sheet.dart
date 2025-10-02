
import 'package:flutter/material.dart';

enum SheetSide { top, right, bottom, left }

/// Sheet widget similar to Radix Dialog/Sheet
class Sheet extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final SheetSide side;
  final double widthFraction; // For left/right sheets
  final double maxWidth;      // Max width for left/right sheets
  final VoidCallback? onClose;

  const Sheet({
    Key? key,
    required this.child,
    this.isOpen = false,
    this.side = SheetSide.right,
    this.widthFraction = 0.75,
    this.maxWidth = 300,
    this.onClose,
  }) : super(key: key);

  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<Sheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: _getOffsetForSide(widget.side),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isOpen) _controller.forward();
  }

  Offset _getOffsetForSide(SheetSide side) {
    switch (side) {
      case SheetSide.right:
        return const Offset(1.0, 0);
      case SheetSide.left:
        return const Offset(-1.0, 0);
      case SheetSide.top:
        return const Offset(0, -1.0);
      case SheetSide.bottom:
        return const Offset(0, 1.0);
    }
  }

  @override
  void didUpdateWidget(covariant Sheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _getAlignment() {
    switch (widget.side) {
      case SheetSide.right:
        return Alignment.centerRight;
      case SheetSide.left:
        return Alignment.centerLeft;
      case SheetSide.top:
        return Alignment.topCenter;
      case SheetSide.bottom:
        return Alignment.bottomCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isOpen
        ? Stack(
            children: [
              // Overlay
              FadeTransition(
                opacity: _opacityAnimation,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              // Sheet Content
              Align(
                alignment: _getAlignment(),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Material(
                    elevation: 16,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      width: (widget.side == SheetSide.left || widget.side == SheetSide.right)
                          ? MediaQuery.of(context).size.width * widget.widthFraction
                          : double.infinity,
                      height: (widget.side == SheetSide.top || widget.side == SheetSide.bottom)
                          ? null
                          : double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: widget.maxWidth,
                      ),
                      child: Stack(
                        children: [
                          widget.child,
                          // Close Button
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              icon: Icon(Icons.close, size: 24),
                              onPressed: widget.onClose,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

/// Optional: Sheet Header
class SheetHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SheetHeader({Key? key, required this.child, this.padding = const EdgeInsets.all(16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Optional: Sheet Footer
class SheetFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SheetFooter({Key? key, required this.child, this.padding = const EdgeInsets.all(16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Sheet Title
class SheetTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const SheetTitle({Key? key, required this.title, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Sheet Description
class SheetDescription extends StatelessWidget {
  final String description;
  final TextStyle? style;

  const SheetDescription({Key? key, required this.description, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
    );
  }
}


import 'package:flutter/material.dart';

/// HoverCard Widget
class HoverCard extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final Alignment contentAlignment;
  final double sideOffset;

  const HoverCard({
    Key? key,
    required this.trigger,
    required this.content,
    this.contentAlignment = Alignment.center,
    this.sideOffset = 4.0,
  }) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  void _onEnter(PointerEvent event) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.trigger,
          if (_isHovered)
            Positioned(
              top: widget.sideOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: widget.contentAlignment,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 256, // Equivalent to w-64 in Tailwind
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: widget.content,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

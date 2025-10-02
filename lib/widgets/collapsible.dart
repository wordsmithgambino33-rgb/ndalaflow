
import 'package:flutter/material.dart';

/// Collapsible widget root
class Collapsible extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final Curve animationCurve;

  const Collapsible({
    Key? key,
    required this.trigger,
    required this.content,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: widget.trigger,
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: widget.content,
        ),
      ],
    );
  }
}

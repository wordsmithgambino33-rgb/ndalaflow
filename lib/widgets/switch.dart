
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late bool _value;
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;

  @override
  void initState() {
    super.initState();
    _value = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _thumbAnimation = Tween<double>(begin: 0, end: 24.0) // Thumb move distance
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_value) _controller.value = 1.0;
  }

  void _toggleSwitch() {
    if (widget.disabled) return;

    setState(() {
      _value = !_value;
      if (_value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onChanged?.call(_value);
    });
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.disabled) return Colors.grey.shade300;
    return _value
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor.withOpacity(0.2);
  }

  Color _getThumbColor(BuildContext context) {
    if (widget.disabled) return Colors.grey.shade400;
    return _value
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: SizedBox(
        width: 32,
        height: 20,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track
            Container(
              width: 32,
              height: 20,
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Thumb
            AnimatedBuilder(
              animation: _thumbAnimation,
              builder: (context, child) {
                return Positioned(
                  left: _thumbAnimation.value,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getThumbColor(context),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0, 1),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

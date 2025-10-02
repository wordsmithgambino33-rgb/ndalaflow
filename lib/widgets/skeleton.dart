
import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[700], // equivalent to bg-accent
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: const _SkeletonPulse(),
    );
  }
}

// Internal widget for the pulsing animation
class _SkeletonPulse extends StatefulWidget {
  const _SkeletonPulse({super.key});

  @override
  State<_SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<_SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);

  late final Animation<double> _animation =
      Tween<double>(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        color: Colors.grey[700],
      ),
    );
  }
}


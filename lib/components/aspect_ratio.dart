
import 'package:flutter/material.dart';

class CustomAspectRatio extends StatelessWidget {
  final double aspectRatio;
  final Widget? child;
  final Key? key;

  const CustomAspectRatio({
    this.key,
    required this.aspectRatio,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: key ?? const Key('aspect-ratio'), // Equivalent to data-slot for identification
      aspectRatio: aspectRatio,
      child: child,
    );
  }
}
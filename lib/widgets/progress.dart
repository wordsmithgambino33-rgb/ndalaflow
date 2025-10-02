
import 'package:flutter/material.dart';

/// Custom Progress Bar Widget
class Progress extends StatelessWidget {
  final double value; // Progress value from 0 to 100
  final double height; // Height of the progress bar
  final Color backgroundColor; // Background of the track
  final Color indicatorColor; // Color of the progress indicator
  final BorderRadius? borderRadius; // Optional border radius

  const Progress({
    Key? key,
    this.value = 0,
    this.height = 8.0,
    this.backgroundColor = const Color(0x33007AFF), // bg-primary/20 equivalent
    this.indicatorColor = const Color(0xFF007AFF), // bg-primary
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Clamp value to 0-100
    final clampedValue = value.clamp(0, 100) / 100;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(100),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * clampedValue,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: borderRadius ?? BorderRadius.circular(100),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

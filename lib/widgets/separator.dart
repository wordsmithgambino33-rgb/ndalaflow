
import 'package:flutter/material.dart';

/// Separator widget, supports horizontal and vertical orientations
class Separator extends StatelessWidget {
  final Axis orientation;
  final bool decorative;
  final double? thickness;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const Separator({
    Key? key,
    this.orientation = Axis.horizontal,
    this.decorative = true,
    this.thickness,
    this.color,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final separatorColor = color ?? Theme.of(context).dividerColor;
    final separatorThickness = thickness ?? 1.0;

    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: orientation == Axis.horizontal ? double.infinity : separatorThickness,
      height: orientation == Axis.horizontal ? separatorThickness : double.infinity,
      color: decorative ? separatorColor : Colors.transparent,
    );
  }
}

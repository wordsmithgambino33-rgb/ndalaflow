
import 'package:flutter/material.dart';

/// A group of resizable panels.
/// Can be horizontal or vertical.
class ResizablePanelGroup extends StatefulWidget {
  final Axis direction;
  final List<Widget> children;
  final double dividerThickness;
  final Color dividerColor;

  const ResizablePanelGroup({
    Key? key,
    required this.children,
    this.direction = Axis.horizontal,
    this.dividerThickness = 8.0,
    this.dividerColor = Colors.grey,
  }) : super(key: key);

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  late List<double> _flexValues;

  @override
  void initState() {
    super.initState();
    // Initialize equal flex for all panels
    _flexValues = List<double>.filled(widget.children.length, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> panels = [];

    for (int i = 0; i < widget.children.length; i++) {
      // Panel itself
      panels.add(
        Expanded(
          flex: (_flexValues[i] * 1000).toInt(),
          child: widget.children[i],
        ),
      );

      // Add handle between panels
      if (i < widget.children.length - 1) {
        panels.add(
          _ResizableHandle(
            axis: widget.direction,
            onDrag: (delta) {
              setState(() {
                double total = _flexValues[i] + _flexValues[i + 1];
                double deltaFlex = delta / 300; // Adjust sensitivity
                _flexValues[i] += deltaFlex;
                _flexValues[i + 1] -= deltaFlex;

                // Prevent negative sizes
                if (_flexValues[i] < 0.1) {
                  _flexValues[i + 1] += _flexValues[i] - 0.1;
                  _flexValues[i] = 0.1;
                }
                if (_flexValues[i + 1] < 0.1) {
                  _flexValues[i] += _flexValues[i + 1] - 0.1;
                  _flexValues[i + 1] = 0.1;
                }

                // Normalize to keep sum stable
                double sum = _flexValues.reduce((a, b) => a + b);
                _flexValues = _flexValues.map((f) => f / sum).toList();
              });
            },
            thickness: widget.dividerThickness,
            color: widget.dividerColor,
          ),
        );
      }
    }

    return Flex(
      direction: widget.direction,
      children: panels,
    );
  }
}

/// Draggable handle for resizing panels
class _ResizableHandle extends StatelessWidget {
  final Axis axis;
  final Function(double delta) onDrag;
  final double thickness;
  final Color color;

  const _ResizableHandle({
    Key? key,
    required this.axis,
    required this.onDrag,
    this.thickness = 8.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (details) {
        double delta = axis == Axis.horizontal ? details.delta.dx : details.delta.dy;
        onDrag(delta);
      },
      child: MouseRegion(
        cursor: axis == Axis.horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow,
        child: Container(
          width: axis == Axis.horizontal ? thickness : double.infinity,
          height: axis == Axis.vertical ? thickness : double.infinity,
          color: color.withOpacity(0.3),
          child: Center(
            child: axis == Axis.horizontal
                ? Container(
                    width: 2,
                    height: 24,
                    color: color,
                  )
                : Container(
                    width: 24,
                    height: 2,
                    color: color,
                  ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

enum SliderOrientation { horizontal, vertical }

class CustomSlider extends StatefulWidget {
  final List<double>? values; // support multiple thumbs
  final double min;
  final double max;
  final bool isDisabled;
  final SliderOrientation orientation;
  final ValueChanged<List<double>>? onChanged;

  const CustomSlider({
    super.key,
    this.values,
    this.min = 0,
    this.max = 100,
    this.isDisabled = false,
    this.orientation = SliderOrientation.horizontal,
    this.onChanged,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late List<double> _values;

  @override
  void initState() {
    super.initState();
    _values = widget.values ??
        [widget.min, widget.max]; // default range if none provided
  }

  @override
  void didUpdateWidget(CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != null) {
      _values = widget.values!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRange = _values.length == 2;

    Widget sliderWidget;

    if (isRange) {
      sliderWidget = RangeSlider(
        values: RangeValues(_values[0], _values[1]),
        min: widget.min,
        max: widget.max,
        onChanged: widget.isDisabled
            ? null
            : (RangeValues newValues) {
                setState(() {
                  _values[0] = newValues.start;
                  _values[1] = newValues.end;
                });
                widget.onChanged?.call(_values);
              },
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Colors.grey[300],
        divisions: (widget.max - widget.min).toInt(),
      );
    } else {
      sliderWidget = Slider(
        value: _values[0].clamp(widget.min, widget.max),
        min: widget.min,
        max: widget.max,
        onChanged: widget.isDisabled
            ? null
            : (double newValue) {
                setState(() {
                  _values[0] = newValue;
                });
                widget.onChanged?.call(_values);
              },
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Colors.grey[300],
        divisions: (widget.max - widget.min).toInt(),
      );
    }

    if (widget.orientation == SliderOrientation.vertical) {
      // rotate for vertical slider
      return RotatedBox(
        quarterTurns: -1,
        child: SizedBox(
          height: double.infinity,
          width: 40,
          child: sliderWidget,
        ),
      );
    }

    return sliderWidget;
  }
}

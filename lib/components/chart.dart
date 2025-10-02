
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

typedef ChartLabelFormatter = String Function(dynamic value);

class ChartConfig {
  final String? label;
  final IconData? icon;
  final Color? color;
  final Map<String, Color>? theme;

  ChartConfig({this.label, this.icon, this.color, this.theme});
}

class ChartContainer extends StatelessWidget {
  final String? id;
  final List<BarChartGroupData>? barGroups;
  final Map<String, ChartConfig> config;
  final double height;

  const ChartContainer({
    Key? key,
    this.id,
    required this.barGroups,
    required this.config,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(8),
      child: BarChart(
        BarChartData(
          barGroups: barGroups ?? [],
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final key = value.toInt().toString();
                  return Text(
                    config[key]?.label ?? key,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class ChartTooltip extends StatelessWidget {
  final dynamic value;
  final String? label;
  final Color? color;

  const ChartTooltip({Key? key, this.value, this.label, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Text(
                label!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            Text(
              value.toString(),
              style: TextStyle(color: color ?? Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  final Map<String, ChartConfig> config;

  const ChartLegend({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: config.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entry.value.icon != null)
              Icon(entry.value.icon, size: 12, color: entry.value.color),
            if (entry.value.icon == null)
              Container(
                width: 10,
                height: 10,
                color: entry.value.color ?? Colors.grey,
              ),
            SizedBox(width: 4),
            Text(entry.value.label ?? entry.key),
          ],
        );
      }).toList(),
    );
  }
}

 
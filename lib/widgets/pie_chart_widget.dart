import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  const PieChartWidget({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = dataMap.entries.toList();
    final total = entries.fold<double>(0, (p, e) => p + e.value);
    final sections = <PieChartSectionData>[];

    final colors = [
      Theme.of(context).colorScheme.primary,
      Colors.amber,
      Colors.green,
      Colors.deepPurple,
      Colors.cyan,
      Colors.orangeAccent,
      Colors.pinkAccent
    ];

    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final value = e.value;
      final percent = total == 0 ? 0.0 : (value / total * 100);
      sections.add(PieChartSectionData(
        value: value,
        title: '${percent.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        color: colors[i % colors.length],
      ));
    }

    if (sections.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return PieChart(
      PieChartData(
        centerSpaceRadius: 28,
        sections: sections,
        sectionsSpace: 4,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

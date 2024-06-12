import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// WeeklyBarChart Widget
///
/// This widget represents a weekly bar chart, displaying data for each day of the week.
/// It utilizes the 'fl_chart' library to render a customizable bar chart with titles
/// for each day of the week on the x-axis and numerical values on the y-axis.
/// The chart is visually styled with different colors for each bar group, representing
/// different data sets or categories.
class WeeklyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(20),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Pon',
                          style: TextStyle(
                              color: Color.fromARGB(255, 226, 136, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold));
                    case 1:
                      return const Text('Uto',
                          style: TextStyle(
                              color: Color.fromARGB(255, 226, 136, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold));
                    case 2:
                      return const Text('Sri',
                          style: TextStyle(
                              color: Color.fromARGB(255, 226, 136, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold));
                    case 3:
                      return const Text('Čet',
                          style: TextStyle(
                              color: Color.fromARGB(255, 226, 136, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold));
                    case 4:
                      return const Text('Pet',
                          style: TextStyle(
                              color: Color.fromARGB(255, 226, 136, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == 50) {
                    return Text('${value.toInt()}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 226, 136, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold));
                  }
                  return const Text('');
                },
                reservedSize: 28,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(
            show: false,
            border: Border.all(
              color: const Color.fromARGB(219, 1, 100, 66),
              width: 0.5,
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(toY: 10, color: Colors.orange, width: 16),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                    toY: 23, color: Theme.of(context).hintColor, width: 16),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                    toY: 18,
                    color: const Color.fromRGBO(254, 198, 1, 1),
                    width: 16),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(toY: 25, color: Colors.orange, width: 16),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                    toY: 32,
                    color: const Color.fromARGB(255, 107, 169, 255),
                    width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

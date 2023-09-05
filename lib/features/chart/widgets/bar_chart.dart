import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final List<double>? weekData;

  const BarChartWidget({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: 6,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 5,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toString(),
              const TextStyle(
                // color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '월';
        break;
      case 1:
        text = '화';
        break;
      case 2:
        text = '수';
        break;
      case 3:
        text = '목';
        break;
      case 4:
        text = '금';
        break;
      case 5:
        text = '토';
        break;
      case 6:
        text = '일';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ));

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          // Colors.grey,
          // Colors.black,
          // Color(0xff02d39a),
          // Color(0xff23b6e6),
          // Color(0xff23b6e6),
          // Colors.amberAccent.withOpacity(0.4),
          Colors.amber,
          Colors.amberAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => List.generate(7, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: weekData![index].toDouble(),
              gradient: _barsGradient,
              width: 10,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        );
      }).toList();
}

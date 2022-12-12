import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatheria/models/weather.dart';

class TempChart extends StatefulWidget {
  final Temp dailyTemp;
  const TempChart({
    super.key,
    required this.dailyTemp,
  });

  @override
  State<TempChart> createState() => _TempChartState(dailyTemp);
}

class _TempChartState extends State<TempChart> {
  final Temp dailyTemp;
  _TempChartState(this.dailyTemp);
  bool showAvg = false;
  DateFormat formattedDate = DateFormat("HH:mm a");

  List<Color> gradientColors = [
    const Color(0xff544151),
    const Color(0xff544151),
  ];

  late List<FlSpot> _spots;
  late Future future;
  @override
  void initState() {
    future = createFlSpots(dailyTemp);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return LineChart(
                mainData(),
              );
            }),
      ],
    );
  }

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
  ) {
    const style = TextStyle(
      color: Color(0xFF544151),
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    const styleTwo = TextStyle(
      color: Color(0xFF544151),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget _widget;

    switch (value.toInt()) {
      case 0:
        _widget = Column(
          children: [
            const Text('Morning', style: style),
            Text("${dailyTemp.morn.toStringAsFixed(0)}°", style: styleTwo),
          ],
        );
        break;
      case 1:
        _widget = Column(
          children: [
            const Text('Afternoon', style: style),
            Text("${dailyTemp.day.toStringAsFixed(0)}°", style: styleTwo),
          ],
        );
        break;
      case 2:
        _widget = Column(
          children: [
            const Text('Evening', style: style),
            Text("${dailyTemp.eve.toStringAsFixed(0)}°", style: styleTwo),
          ],
        );
        break;
      case 3:
        _widget = Column(
          children: [
            const Text('Night', style: style),
            Text("${dailyTemp.night.toStringAsFixed(0)}°", style: styleTwo),
          ],
        );
        break;
      default:
        _widget = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: _widget,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
          show: true, drawVerticalLine: true, drawHorizontalLine: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      minY: 0,
      maxY: dailyTemp.max,
      lineBarsData: [
        LineChartBarData(
          spots: _spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }

  Future<String?> createFlSpots(Temp _temp) async {
    List<FlSpot> spots = [];
    spots.add(FlSpot(0, _temp.morn));
    spots.add(FlSpot(1, _temp.day));
    spots.add(FlSpot(2, _temp.eve));
    spots.add(FlSpot(3, _temp.night));
    _spots = spots;
    return "done";
  }
}

import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/main.dart';

class BarChartPrizepot extends StatefulWidget {
  BarChartPrizepot({Key key, this.dates, this.color}) : super(key: key);

  List dates;
  Color color;

  @override
  State<StatefulWidget> createState() => BarChartPrizepotState();
}

class BarChartPrizepotState extends State<BarChartPrizepot> {
  Color barBackgroundColor;
  Color barColor;
  final Duration animDuration = Duration(milliseconds: 250);
  int touchedIndex;

  bool isPlaying = false;


  @override
  Widget build(BuildContext context) {
    barBackgroundColor = color3.withOpacity(0.3);
    barColor = color3;
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Prizepot size development',
                    style: TextStyle(
                        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'last 7 days',
                    style: TextStyle(
                        color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.dates.length > 6 ? widget.dates[widget.dates.length - 7] : 0, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, widget.dates.length > 5 ? widget.dates[widget.dates.length - 6] : 0, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, widget.dates.length > 4 ? widget.dates[widget.dates.length - 5] : 0, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, widget.dates.length > 3 ? widget.dates[widget.dates.length - 4] : 0, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, widget.dates.length > 2 ? widget.dates[widget.dates.length - 3] : 0, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, widget.dates.length > 1 ? widget.dates[widget.dates.length - 2] : 0, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, widget.dates.length > 0 ? widget.dates[widget.dates.length - 1] : 0, isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = 'Prizepot size';
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '-6';
              case 1:
                return '-5';
              case 2:
                return '-4';
              case 3:
                return '-3';
              case 4:
                return '-2';
              case 5:
                return '-1';
              case 6:
                return 'today';
              default:
                return '';
            }
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
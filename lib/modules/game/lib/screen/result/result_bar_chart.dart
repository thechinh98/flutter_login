import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:game/model/core/done_test.dart';
import 'package:game/model/core/test_score.dart';
import 'package:game/providers/user_model.dart';
import 'package:provider/provider.dart';

class ResultBarChart extends StatefulWidget {
  final List<TestScore> listScore;
  const ResultBarChart({
    Key? key,required this.listScore,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ResultBarChartState();
}

class ResultBarChartState extends State<ResultBarChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  List<TestScore> get listTestScore => widget.listScore;
  bool isPlaying = false;
  // List<TestScore> listTestScore = [TestScore(scoreTitle: "Listening Score", point: 300),TestScore(scoreTitle: "Reading", point: 300) ];

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff81e5cd),
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
                    'TOEIC TEST',
                    style: TextStyle(
                        color: const Color(0xff0f4a3c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${_userModel.currentUser!.userName}',
                    style: TextStyle(
                        color: const Color(0xff379982),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
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
                    height: 12,
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
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 300,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(listTestScore.length, (index) {
      return makeGroupData(index, listTestScore[index].point.toDouble(),
          isTouched: index == touchedIndex);
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      groupsSpace: 30,
      alignment: BarChartAlignment.center,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return _buildToolTipItem(group, rod);
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
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
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return listTestScore[value.toInt()].scoreTitle;
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarTooltipItem _buildToolTipItem(BarChartGroupData group, BarChartRodData rod) {
    return BarTooltipItem(
      "${listTestScore[group.x.toInt()].scoreTitle}" + '\n',
      TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      children: <TextSpan>[
        TextSpan(
          text: (rod.y - 1).toString(),
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

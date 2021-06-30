import 'package:flutter/material.dart';
import 'package:game/screen/test_progress/bar_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Screen"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              BarChartSample1(),

            ],
          ),
        ),
      ),
    );
  }
}

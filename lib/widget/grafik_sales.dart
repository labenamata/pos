import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

Widget grafikSales() {
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(
        double.parse(index.toString()), index * Random().nextDouble());
  });

  List<Color> gradientColors = [
    primaryColor,
    secondaryColor,
  ];

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      //set border radius more than 50% of height and width to make circle
    ),
    child: SizedBox(
      height: 300,
      //width: double.infinity,
      // decoration: const BoxDecoration(
      //     color: secondaryColor,
      //     borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              'Grafik Penjualan',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const Text(
              'Grafik penjualan harian',
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              color: textColor,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 30,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: primaryColor),
                  ),
                  lineBarsData: [
                    // The red line
                    LineChartBarData(
                      spots: dummyData1,
                      isCurved: true,
                      barWidth: 5,
                      color: primaryColor,
                      dotData: FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

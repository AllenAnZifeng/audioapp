import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:audioapp/screens/authenticate/authHome.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:audioapp/shared/loading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:audioapp/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/appUser.dart';
import '../../services/auth.dart';

class _LineChart extends StatefulWidget {
  final Map<dynamic, dynamic> dataColor;

  const _LineChart({Key? key, required this.dataColor}) : super(key: key);

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(value.toStringAsFixed(2), style: style),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double opacity = 1.0;

    List<LineChartBarData> allSpots = [];

    LineChartBarData getEarData(List<FlSpot> leftSpots, Color color) {
      return LineChartBarData(
        spots: leftSpots,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: color.withOpacity(opacity),
                strokeWidth: 2,
                strokeColor: color.withOpacity(opacity),
              );
            }),
      );
    }

    widget.dataColor.forEach((index, val) {
      // print('data: $data, color: $color');

      allSpots.add(getEarData(val[0], val[1]));
    });

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameSize: 20,
            axisNameWidget: const Text(
              'Frequency - Hz',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta),
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            axisNameSize: 20,
            axisNameWidget: const Text(
              'Volume - dB',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.01,
              getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
              reservedSize: 40,
            ),
          ),
        ),
        lineBarsData: allSpots,
        minX: 0,
        maxX: 8000,
        minY: 0,
        maxY: 0.2,
      ),
      swapAnimationDuration: const Duration(milliseconds: 0),
    );
  }
}

class Test1Result extends StatefulWidget {
  const Test1Result({Key? key}) : super(key: key);

  @override
  State<Test1Result> createState() => _Test1ResultState();
}

class _Test1ResultState extends State<Test1Result> {
  List<bool> checkedStates = [];
  late Widget plot;
  late Widget pastData;
  bool loading = false;
  bool initFlag = true;
  List<Color> colors = [];
  int lastTapped = 0;
  List<Widget> row = [];

  LinkedHashMap dataColorTime = LinkedHashMap(); // index: [data, color, time]
  // Map<dynamic,Color> dataColor = {};
  final List<String> frequencies = [
    '500',
    '1000',
    '2000',
    '3000',
    '4000',
    '6000',
    '8000'
  ];

  String getTitles(value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  List<Color> generateDistinctColors(int n) {
    if (n == 0) {
      return [];
    }
    if (n <= 5) {
      List<Color> result = [];
      List<Color> colors = [
        Colors.purple[100]!,
        Colors.purple[300]!,
        Colors.red[100]!,
        Colors.red[300]!,
        Colors.green[100]!,
        Colors.green[300]!,
        Colors.blue[100]!,
        Colors.blue[300]!,
        Colors.yellow[100]!,
        Colors.yellow[300]!,
      ];

      for (int i = 0; i < n; i++) {
        result.add(colors[2 * i]);
        result.add(colors[2 * i + 1]);
      }

      return result;
    }
    final List<Color> colors = [];
    final Random random = Random();
    final int step = (360 / n).floor();
    // final int initialHue = random.nextInt(360);
    final int initialHue = 100;

    for (int i = 0; i < n; i++) {
      final int hue = (initialHue + i * step) % 360;
      final double saturation = 0.7 + random.nextDouble() * 0.2;
      final double lightness = 0.7 + random.nextDouble() * 0.2;
      final HSLColor hslColorLeft =
          HSLColor.fromAHSL(1.0, hue.toDouble(), saturation, lightness);
      final HSLColor hslColorRight = HSLColor.fromAHSL(
          1.0, hue.toDouble(), saturation + 0.1, lightness + 0.1);

      colors.add(hslColorLeft.toColor());
      colors.add(hslColorRight.toColor());
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);

    if (appUser == null || appUserData == null) {
      return const AuthHome();
    }
    print(appUserData.data);
    if (appUserData.data['test1'].length == 0) {
      setState(() {
        plot = const Text('No data');
        pastData = const Text('No data');
      });
    } else {
      if (initFlag) {
        setState(() {
          checkedStates =
              List<bool>.filled(appUserData.data['test1'].length, false);
          checkedStates[checkedStates.length - 1] = true;
          colors = generateDistinctColors(checkedStates.length);
          initFlag = false;
        });
      }

      if (checkedStates.isEmpty) {
        setState(() {
          loading = true;
        });
      } else {
        setState(() {
          loading = false;
        });
      }

      List filterData = []; // [index, data, time]
      for (int i = 0; i < appUserData.data['test1']!.length; i++) {
        if (checkedStates[i]) {
          filterData.add([
            i,
            appUserData.data['test1']![i],
            appUserData.data['test1']![i]['time']
          ]);
        }
      }

      List<bool> flatCheckedStates = [];
      for (int i = 0; i < checkedStates.length; i++) {
        if (checkedStates[i]) {
          flatCheckedStates.add(true);
          flatCheckedStates.add(true);
        } else {
          flatCheckedStates.add(false);
          flatCheckedStates.add(false);
        }
      }

      List filterColor = List.generate(colors.length, (i) => colors[i])
          .where((e) => flatCheckedStates[colors.indexOf(e)])
          .toList();
      print('filterData  ${filterData}');
      print('All Colors ${colors}');
      print('filterColor ${filterColor}');
      print('flatCheckedStates ${flatCheckedStates}');

      setState(() {
        dataColorTime = LinkedHashMap();
        row = [];
      });

      for (int i = 0; i < filterData.length; i++) {
        List<FlSpot> leftSpots = [];
        List<FlSpot> rightSpots = [];
        for (String frequency in frequencies) {
          leftSpots.add(FlSpot(double.parse(frequency),
              filterData[i][1][frequency][0].toDouble()));
          rightSpots.add(FlSpot(double.parse(frequency),
              filterData[i][1][frequency][1].toDouble()));
        }
        setState(() {
          dataColorTime[2 * filterData[i][0]] = [
            leftSpots,
            filterColor[2 * i],
            filterData[i][2]
          ];
          dataColorTime[2 * filterData[i][0] + 1] = [
            rightSpots,
            filterColor[2 * i + 1],
            filterData[i][2]
          ];
        });
      }

      if (checkedStates[lastTapped]) {
        var tempData1 = dataColorTime.remove(2 * lastTapped);
        var tempData2 = dataColorTime.remove(2 * lastTapped + 1);
        dataColorTime[2 * lastTapped] = tempData1;
        dataColorTime[2 * lastTapped + 1] = tempData2;
      }

      print('dataColor $dataColorTime');

      bool flag = true;
      List<Widget> temp = [];
      dataColorTime.forEach((index, val) {
        // print('data: $data, color: $color');

        if (flag) {
          temp.add(Text(
            '${getTitles(val[2])} -- ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.0),
          ));
          temp.add(const SizedBox(width: 4));
        }
        temp.add(Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: val[1], shape: BoxShape.circle),
        ));
        temp.add(const SizedBox(width: 4));
        if (flag) {
          temp.add(const Text('Left Ear ', style: TextStyle(fontSize: 12)));
          flag = false;

        } else {
          temp.add(const Text('Right Ear', style: TextStyle(fontSize: 12)));
          flag = true;
          setState(() {
            row.add(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: temp,
            ));
          });
          temp = [];
        }

      });

      setState(() {
        plot = _LineChart(dataColor: dataColorTime);
        pastData = ListView.builder(
            itemCount: appUserData.data['test1'].length,
            shrinkWrap: true,
            reverse: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        lastTapped = index;
                        checkedStates[index] = !checkedStates[index];
                      });

                      print('tapping $index');
                      print(checkedStates);
                    },
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: AssetImage('assets/ears.png'),
                      ),
                      title: Text(
                          getTitles(appUserData.data['test1']![index]['time'])),
                      subtitle: const Text('Test Results'),
                      trailing: Icon(
                        checkedStates[index]
                            ? Icons.check_circle
                            : Icons.circle,
                        color: checkedStates[index]
                            ? Colors.purple[400]
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            });
      });
    }

    return loading
        ? Loading()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0, width: double.infinity),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Test 1 Results',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                pastData,
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Audiometry Results',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, right: 40, left: 20),
                    child: plot,
                  ),
                ),
                const SizedBox(height: 5.0, width: double.infinity),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row,
                ),
                const SizedBox(height: 50.0, width: double.infinity),
              ],
            ),
          );
  }
}

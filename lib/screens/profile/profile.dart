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
  final List<dynamic> data;
  final List<dynamic> colors;

  const _LineChart({Key? key, required this.data, required this.colors})
      : super(key: key);

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  List<int> _lineOrder = []; // Initial order of the lines

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data.length; i++) {
      setState(() {
        _lineOrder.add(i);
      });
    }
  }

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

    List<String> frequencies = [
      '500',
      '1000',
      '2000',
      '3000',
      '4000',
      '6000',
      '8000'
    ];

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



    for (int i = 0; i < widget.data.length; i++) {
      List<FlSpot> leftSpots = [];
      List<FlSpot> rightSpots = [];
      for (String frequency in frequencies) {
        leftSpots.add(FlSpot(
            double.parse(frequency), widget.data[i][frequency][0].toDouble()));
        rightSpots.add(FlSpot(
            double.parse(frequency), widget.data[i][frequency][1].toDouble()));
      }
      allSpots.add(getEarData(leftSpots, widget.colors[2 * i]));
      allSpots.add(getEarData(rightSpots, widget.colors[2 * i + 1]));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
          ),
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            // move the touched line to the fore ground
            if (touchResponse != null &&
                touchResponse.lineBarSpots != null &&
                touchResponse.lineBarSpots!.isNotEmpty) {
              final int touchedLineIndex =
                  touchResponse.lineBarSpots![0].barIndex;
              setState(() {
                _lineOrder = [touchedLineIndex, 1 - touchedLineIndex];
              });
            }
          },
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
    );
  }
}

class Profile extends StatefulWidget {
  // final Function toggleView;
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  List<bool> checkedStates = [];
  late Widget plot;
  late Widget pastData;
  bool loading = false;
  bool initFlag = true;
  List<Color> colors = [];

  String getTitles(value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    return '${date.year}/${date.month}/${date.day}';
  }

  List<Color> generateDistinctColors(int n) {
    if (n == 0) {
      return [];
    }
    final List<Color> colors = [];
    final Random random = Random();
    final int step = (360 / n).floor();
    final int initialHue = random.nextInt(360);

    for (int i = 0; i < n; i++) {
      final int hue = (initialHue + i * step) % 360;
      final double saturation = 0.5 + random.nextDouble() * 0.4; // 50% to 90%
      final double lightness = 0.5 + random.nextDouble() * 0.4; // 50% to 90%
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

    String time = '';

    // print('Profile appUser: $appUser');
    // print('Profile appUserData: $appUserData');

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

      time = getTitles(appUserData.data['test1']!.last['time']);
      List data = List.generate(appUserData.data['test1'].length,
              (i) => appUserData.data['test1'][i])
          .where((e) => checkedStates[appUserData.data['test1'].indexOf(e)])
          .toList();
      print('data ${data.length}');

      List<bool> tempBool = [];
      for (int i = 0; i < checkedStates.length; i++) {
        if (checkedStates[i]) {
          tempBool.add(true);
          tempBool.add(true);
        } else {
          tempBool.add(false);
          tempBool.add(false);
        }
      }

      List tempColor = List.generate(colors.length, (i) => colors[i])
          .where((e) => tempBool[colors.indexOf(e)])
          .toList();
      print('Color ${colors}');
      print('tempColor ${tempColor}');

      setState(() {
        plot = _LineChart(data: data, colors: tempColor);
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
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple[600],
              scrolledUnderElevation: 4.0,
              elevation: 0,
              title: const Text(
                'Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.pink[50],
                  ),
                  label: const Text('logout',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => {GoRouter.of(context).go('/home')},
                  icon: Icon(
                    Icons.home,
                    color: Colors.pink[50],
                  ),
                  label: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text('Home',
                        style: TextStyle(
                          fontSize: 18.0,
                        )),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$time -- ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.purple[100], shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      const Text('Left Ear', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.green[100], shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      const Text('Right Ear', style: TextStyle(fontSize: 12)),
                    ],
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
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'All Test Results',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  pastData,
                  const SizedBox(height: 50.0, width: double.infinity),
                ],
              ),
            ),
          );
  }
}

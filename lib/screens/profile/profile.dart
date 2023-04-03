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



class _LineChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const _LineChart({Key? key, required this.data}) : super(key: key);

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
    print('data $data');

    List<FlSpot> leftSpots = [];
    List<FlSpot> rightSpots = [];


    List<String> frequencies = [
      '500',
      '1000',
      '2000',
      '3000',
      '4000',
      '6000',
      '8000'
    ];
    for (String frequency in frequencies) {
      leftSpots
          .add(FlSpot(double.parse(frequency), data[frequency][0].toDouble()));
      rightSpots
          .add(FlSpot(double.parse(frequency), data[frequency][1].toDouble()));
    }

    const double opacity = 1.0;

    final LineChartBarData leftEarLineData = LineChartBarData(
      spots: leftSpots,
      color: Colors.purple[100],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: Colors.purple[100]?.withOpacity(opacity),
              strokeWidth: 6,
              strokeColor: Colors.purple[100]?.withOpacity(opacity),
            );
          }
      ),
    );

    final LineChartBarData rightEarLineData = LineChartBarData(
      spots: rightSpots,
      color: Colors.green[100],
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.green[100]?.withOpacity(opacity),
            strokeWidth: 2,
            strokeColor: Colors.green[100]?.withOpacity(opacity),
          );
        }
      ),
    );

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
        lineBarsData: [
          leftEarLineData,
          rightEarLineData,
        ],
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

  late Widget content;

  String getTitles(value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);
    String time = '';

    print('Profile appUser: $appUser');
    print('Profile appUserData: $appUserData');

    if (appUser == null || appUserData == null) {
      return const AuthHome();
    }
    print(appUserData.data);
    if (appUserData.data['test1'].length == 0) {
      setState(() {
        content = const Text('No data');
      });
    } else {
      time = getTitles( appUserData.data['test1']!.last['time']);
      setState(() {
        content = _LineChart(data: appUserData.data['test1']!.last);
      });
    }



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        scrolledUnderElevation: 4.0,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
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
      body: Column(
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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Audiogram $time',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: Colors.purple[100], shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            const Text('Left Ear', style: TextStyle(fontSize: 12)),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: Colors.green[100], shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            const Text('  Right Ear', style: TextStyle(fontSize: 12)),
          ],
        ),
          const SizedBox(height: 20.0, width: double.infinity),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, right: 40, left: 20),
              child: content,
            ),
          ),
          const SizedBox(height: 50.0, width: double.infinity),
        ],
      ),
    );
  }
}

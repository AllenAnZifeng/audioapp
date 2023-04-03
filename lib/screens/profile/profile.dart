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
      space: 10,
      child: Text(meta.formattedValue, style: style),

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

    List<FlSpot> spots = [];

    List<String> frequencies = ['500', '1000', '2000', '3000', '4000', '6000', '8000'];
    for (String frequency in frequencies) {

      spots.add(FlSpot(double.parse(frequency), data[frequency][0].toDouble()));

    }



    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
          ),
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: const Text(
                'Frequency',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta),
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: const Text(
                'Volume',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    leftTitleWidgets(value, meta),
                reservedSize: 40,
              ),
            ),
          ),
        lineBarsData: [
          LineChartBarData(spots: spots,
            color: Colors.purple[100],),
          // LineChartBarData(spots: [
          //   FlSpot(3, 3),
          //   FlSpot(4, 4),
          //   FlSpot(5, 10),
          // ], color: Colors.blue[100],),
        ],
        minX: 0,
        maxX: 8000,
        minY: 0,
        maxY: 0.1,

      ),
      swapAnimationDuration: Duration(milliseconds: 150),
      // Optional
      swapAnimationCurve: Curves.linear, // Optional



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

  @override
  Widget build(BuildContext context) {

    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);

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
    }else {
      setState(() {
        content = _LineChart( data: appUserData.data['test1']!.last);
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
            onPressed: () => {
            GoRouter.of(context).go('/home')
            },
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50,right: 16, left: 6),
              child: content,
            ),
          ),

        ],
      ),
    );
  }
}



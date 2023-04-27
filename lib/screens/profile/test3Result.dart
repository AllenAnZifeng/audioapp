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

class FMDetectionResultsList extends StatelessWidget {
  final List<String> FMDetectionDescriptions = [
    'Good temporal processing: the ability to efficiently and accurately detect and process temporal changes in auditory stimuli - Enhanced speech perception, Accurate pitch perception, Accurate sound localization',
    'Bad temporal processing: reduced or impaired ability to process and analyze time-based information in auditory stimuli - Impaired speech perception, Poor pitch perception, Inaccurate sound localization',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: FMDetectionDescriptions.length,
      shrinkWrap: true,
      reverse: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(FMDetectionDescriptions[index]),
            ),
          ),
        );
      },
    );
  }
}

class Test3Result extends StatefulWidget {
  const Test3Result({Key? key}) : super(key: key);

  @override
  State<Test3Result> createState() => _Test3ResultState();
}

class _Test3ResultState extends State<Test3Result> {


  late Widget pastData;
  Widget description = FMDetectionResultsList();


  @override
  initState() {
    super.initState();
  }


  String getTitles(value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);

    if (appUser == null || appUserData == null) {
      return const AuthHome();
    }
    print(appUserData.data);
    if (appUserData.data['test3'] == null || appUserData.data['test3'].isEmpty ) {
      setState(() {
        pastData = const Text('No data');
      });
    } else {
      setState(() {
        pastData = ListView.builder(
            itemCount: appUserData.data['test3'].length,
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

                      print('tapping $index');

                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        child: Image.asset(
                          'assets/test3.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      title: Text(
                          getTitles(appUserData.data['test3']![index]['time'])),
                      subtitle: Text(appUserData.data['test3']![index]['temporalProcessing']),
                    ),
                  ),
                ),
              );
            });
      });
    }



    return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0, width: double.infinity),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'FM Detection Results',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                pastData,
                const SizedBox(height: 50.0, width: double.infinity),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Results Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                description,
                const SizedBox(height: 50.0, width: double.infinity),
              ],
            ),
          );
  }
}

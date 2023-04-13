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

class DINResultsList extends StatelessWidget {
  final List<String> dinDescriptions = [
    'Normal hearing: Individuals with normal hearing can accurately perceive and understand spoken digits even in the presence of background noise. They typically experience little to no difficulty in understanding speech in noisy environments, such as busy streets, restaurants, or social gatherings.',
    'Mild hearing loss: People with mild hearing loss might experience some challenges in understanding spoken digits in noisy environments, but they can still manage to comprehend speech to a certain extent. They may need to rely more on visual cues, such as lip reading or facial expressions, to compensate for the reduced hearing ability.',
    // 'Moderate hearing loss: Those with moderate hearing loss struggle to understand speech when background noise is present. They often require the use of hearing aids to improve their hearing ability in noisy situations. In addition, they might need to ask others to speak more slowly, clearly, or loudly to facilitate better communication.',
    'Severe hearing loss: Individuals with severe hearing loss have significant difficulty understanding spoken digits in the presence of background noise, even with the use of hearing aids. They may rely heavily on visual cues, such as sign language, lip reading, or written communication, to communicate effectively. In some cases, cochlear implants might be considered to improve their hearing ability.',
    // 'Profound hearing loss: People with profound hearing loss are unable to perceive speech in noisy environments, even with the use of hearing aids or cochlear implants. They typically rely on alternative methods of communication, such as sign language or written text, to engage with others. In some cases, they may also benefit from assistive listening devices or other technological aids to enhance their communication abilities.',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dinDescriptions.length,
      shrinkWrap: true,
      reverse: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(dinDescriptions[index]),
            ),
          ),
        );
      },
    );
  }
}

class Test2Result extends StatefulWidget {
  const Test2Result({Key? key}) : super(key: key);

  @override
  State<Test2Result> createState() => _Test2ResultState();
}

class _Test2ResultState extends State<Test2Result> {


  late Widget pastData;
  Widget description = DINResultsList();


  @override
  initState() {
    super.initState();
  }



  String getTitles(value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    return '${date.year}/${date.month}/${date.day}';
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
    print('initialHue $initialHue');

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
    if (appUserData.data['test2'] == null || appUserData.data['test2'].isEmpty ) {
      setState(() {
        pastData = const Text('No data');
      });
    } else {
      setState(() {
        pastData = ListView.builder(
            itemCount: appUserData.data['test2'].length,
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
                          'assets/test2.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      title: Text(
                          getTitles(appUserData.data['test2']![index]['time'])),
                      subtitle: Text(appUserData.data['test2']![index]['noiseIntensity']),
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
                    'Digits in Noise Results',
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

import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../../models/appUser.dart';
import '../../services/database.dart';
import '../profile/profile.dart';

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  int score = 0;
  bool buttonVisible = false;

  String buttonState = 'Start';

  // String buttonState = 'End';
  Map<String, String> textDict = {
    'Start': 'Start',
    'InTest': 'Make a choice',
    'Loading': 'Loading...',
    'End': 'Go to Profile',
  };
  List<Widget> buttons = [];
  String file = '';
  Map<String, dynamic> data = {};

  final player = AudioPlayer();
  List<String> fileNamesPureTone = [
    'pure_tone_500.wav',
    'pure_tone_1000.wav',
  ];

  List<String> fileNamesStereo = [
    'stereo_signal_1000.mp3',
  ];

  @override
  initState() {
    super.initState();
    setState(() {
      buttons = generateButtons();
    });

    String randomFileName = getRandomFileName(fileNamesPureTone);

    setState(() {
      file = randomFileName;
    });

    print('Random file name: $randomFileName');
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  String getRandomFileName(List filenames) {
    final random = Random();
    int randomIndex = random.nextInt(filenames.length);
    String randomFileName = filenames[randomIndex];

    return randomFileName;
  }

  bool isPureTone(String fileName) {
    List<String> splitName = fileName.split('_');
    String pure = splitName[0];
    if (pure == 'pure') {
      return true;
    } else {
      return false;
    }
  }

  playAudio() async {
    await player.play(AssetSource("audio/$file"));
  }

  startTest() async {
    await playAudio();
    setState(() {
      buttonState = 'InTest';
      buttonVisible = true;
      buttons = generateButtons();
    });
  }

  submitData() async {
    setState(() {
      buttons = [];
    });
    setState(() {
      buttonState = 'Loading';
      buttonVisible = false;
    });

    if (score < 2) {
      data['temporalProcessing'] = 'Bad temporal processing';
    } else {
      data['temporalProcessing'] = 'Good temporal processing';
    }
    setState(() {
      data['time'] = DateTime.now().millisecondsSinceEpoch.toString();
    });
    print(data);
    final appUser = Provider.of<AppUser?>(context, listen: false);
    await DatabaseService(uid: appUser!.uid).updateUserAudioData('test3', data);
    setState(() {
      buttonState = 'End';
    });
  }

  Future<void> _endDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congrats!'),
          content: const Text('You have successfully completed the test.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Next'),
              onPressed: () {
                GoRouter.of(context).go('/profile/2');
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> generateButtons() {
    if (isPureTone(file)) {
      var trueChoice = ElevatedButton(
        onPressed: () async {
          setState(() {
            score += 1;
            file = getRandomFileName(fileNamesStereo);
            buttonState = 'Loading';
          });
          // wait for 1 second
          await Future.delayed(const Duration(seconds: 1));
          startTest();
        },
        child: const Text('Same',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      );

      var falseChoice = ElevatedButton(
        onPressed: () async {
          setState(() {
            file = getRandomFileName(fileNamesStereo);
            buttonState = 'Loading';
          });
          await Future.delayed(const Duration(seconds: 1));
          startTest();
        },
        child: const Text('Different',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      );

      var buttons = [
        if (buttonVisible) trueChoice,
        if (buttonVisible) falseChoice,
      ];

      return buttons;
    } else {
      var trueChoice = ElevatedButton(
        onPressed: () async {
          setState(() {
            score += 1;
          });
          await submitData();
          await _endDialogBuilder(context);
        },
        child: const Text('Different',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      );

      var falseChoice = ElevatedButton(
        onPressed: () async {
          await submitData();
          await _endDialogBuilder(context);
        },
        child: const Text('Same',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      );

      var buttons = [
        if (buttonVisible) falseChoice,
        if (buttonVisible) trueChoice,
      ];

      return buttons;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        scrolledUnderElevation: 4.0,
        elevation: 0,
        title: const Text(
          'FM Detection Test',
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
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
                'Test started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Decide whether the sounds from two ears are the same or different.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'You will hear two sets for this test.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Make your choice when prompted.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 20.0, width: double.infinity),
            ElevatedButton(
              onPressed: buttonState == 'InTest' || buttonState == 'Loading'
                  ? null
                  : () {
                      if (buttonState == 'Start') {
                        setState(() {
                          buttonState = 'InTest';
                          buttonVisible = true;
                        });
                        startTest();
                      } else if (buttonState == 'InTest') {
                        setState(() {});
                      } else if (buttonState == 'End') {
                        GoRouter.of(context).go('/profile/2');
                      }
                    },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  textDict[buttonState]!,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40.0, width: double.infinity),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons,
            ),
            const SizedBox(height: 40.0, width: double.infinity),
          ],
        ),
      ),
    );
  }
}

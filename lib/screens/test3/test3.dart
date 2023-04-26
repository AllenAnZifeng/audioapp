import 'package:audioapp/screens/profile/test2Result.dart';
import 'package:audioapp/screens/test1/test1.dart';
import 'package:audioapp/screens/test2/test2.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../../models/appUser.dart';
import '../../services/database.dart';
import '../profile/profile.dart';

class ParsedFileName {
  final String digits;
  final double noiseIntensity;

  ParsedFileName({required this.digits, required this.noiseIntensity});
}

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
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
  List<String> fileNamesNormal = [
    '022-0.1.wav',
    '843-0.1.wav',
    '882-0.1.wav',
    '950-0.1.wav',
    '985-0.1.wav',
  ];

  List<String> fileNamesLoss = [
    '518-0.05.wav',
    '658-0.05.wav',
    '670-0.05.wav',
    '773-0.05.wav',
  ];

  @override
  initState() {
    super.initState();
    setState(() {
      buttons = generateButtons();
    });

    String randomFileName = getRandomFileName(fileNamesNormal);

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

  ParsedFileName parseFileName(String fileName) {
    print(fileName);
    if (fileName.length < 3) {
      return ParsedFileName(digits: '000', noiseIntensity: 0.0);
    }
    List<String> splitName = fileName.split('-');
    String digits = splitName[0];
    double noiseIntensity = double.parse(splitName[1].replaceAll('.wav', ''));

    return ParsedFileName(digits: digits, noiseIntensity: noiseIntensity);
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


    double noiseIntensity = parseFileName(file).noiseIntensity;
    if (noiseIntensity == 0.1) {
      data['noiseIntensity'] = 'Normal hearing';
    } else if (noiseIntensity == 0.05) {
      data['noiseIntensity'] = 'Mild Loss';
    } else {
      data['noiseIntensity'] = 'Severe Loss';
    }
    setState(() {
      data['time'] = DateTime.now().millisecondsSinceEpoch.toString();
    });
    print(data);
    final appUser = Provider.of<AppUser?>(context, listen: false);
    await DatabaseService(uid: appUser!.uid).updateUserAudioData('test2', data);
    setState(() {
      buttonState = 'End';

    });

  }

  String generateRandomDigits(String existing_code) {
    final random = Random();
    String result = '';
    bool flag = true;
    while (flag) {
      result = '';
      for (int i = 0; i < 3; i++) {
        int randomNumber = random.nextInt(10);
        result += randomNumber.toString();
      }
      if (result != existing_code) {
        flag = false;
      }
    }

    return result;
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
                GoRouter.of(context).go('/profile/1');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Profile(
                //               initIndex: 1,
                //             )));
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> generateButtons() {
    var falseChoice1 = ElevatedButton(
      onPressed: () async {
        double noiseIntensity = parseFileName(file).noiseIntensity;
        if (noiseIntensity == 0.1) {
          String randomFileName = getRandomFileName(fileNamesLoss);
          setState(() {
            file = randomFileName;
          });

          print('Random file name: $randomFileName');

          await Future.delayed(const Duration(milliseconds: 500), () {});
          startTest();
        } else {
          setState(() {
            file = "000-0.0"; // severe loss
          });
          await submitData();
          await _endDialogBuilder(context);


        }
      },
      child: Text(generateRandomDigits(parseFileName(file).digits),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
    var falseChoice2 =  ElevatedButton(
      onPressed: () async {
        double noiseIntensity = parseFileName(file).noiseIntensity;
        if (noiseIntensity == 0.1) {
          String randomFileName = getRandomFileName(fileNamesLoss);
          setState(() {
            file = randomFileName;
          });

          print('Random file name: $randomFileName');

          await Future.delayed(const Duration(milliseconds: 500), () {});
          startTest();
        } else {
          setState(() {
            file = "000-0.0"; // severe loss
          });
          await submitData();
          await _endDialogBuilder(context);


        }
      },
      child: Text(generateRandomDigits(parseFileName(file).digits),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
    var trueChoice = ElevatedButton(
      onPressed: () async {
        await submitData();
        await _endDialogBuilder(context);


      },
      child: Text(parseFileName(file).digits,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );

    var buttons = [
      if (buttonVisible) trueChoice,
      if (buttonVisible) falseChoice1,
      if (buttonVisible) falseChoice2,
    ];
    buttons.shuffle();
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        scrolledUnderElevation: 4.0,
        elevation: 0,
        title: const Text(
          'DIN Test',
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
                '33Choose the matching digits in the noise.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'You will only hear one or two sets for this test.',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                  initIndex: 1,
                                )));
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

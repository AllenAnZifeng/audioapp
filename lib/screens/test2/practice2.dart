import 'package:audioapp/screens/test1/test1.dart';
import 'package:audioapp/screens/test2/test2.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Practice2 extends StatefulWidget {
  const Practice2({Key? key}) : super(key: key);

  @override
  State<Practice2> createState() => _Practice2State();
}

class _Practice2State extends State<Practice2> {
  bool buttonVisible = false;

  String buttonState = 'Start';
  // String buttonState = 'End';
  Map<String, String> textDict = {
    'Start': 'Start',
    'InTest': 'Make a choice',
    'End': 'Go to Test',
  };
  List<Widget> buttons = [];

  String error ="";
  final player = AudioPlayer();

  @override
  initState() {
    super.initState();
   setState(() {
     buttons = generateButtons();
   });
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  playAudio() async{
    await player.play(AssetSource("audio/097-0.05.wav"));
  }

  startPractice() async {
    await playAudio();
    setState(() {
      buttonState = 'InTest';
      buttonVisible = true;
      buttons = generateButtons();
    });
  }

  String generateRandomDigits(String existing_code) {
    final random = Random();
    String result = '';
    bool flag = true;
    while(flag) {
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


  Future<void> _endPracticeDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Correct Choice!'),
          content: const Text('You have successfully completed the practice.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Go To Test'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Test2()),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          ],
        );
      },
    );
  }

  List<Widget> generateButtons(){
    var buttons = [
      if (buttonVisible)
        ElevatedButton(
          onPressed: () async {
            setState(() {
              buttonState = 'End';
              error= '';
              buttonVisible = false;
            });
            await _endPracticeDialogBuilder(context);
          },
          child: Text('097', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
      if (buttonVisible)
        ElevatedButton(
          onPressed: () {
            setState(() {

              error= '';

            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
                content: Text('Incorrect Choice!'),
                duration: const Duration(milliseconds: 800),
                width: 280.0, // Width of the SnackBar.
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, // Inner padding for SnackBar content.
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          },
          child: Text(generateRandomDigits('097'), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
      if (buttonVisible)
        ElevatedButton(
          onPressed: () {
            setState(() {

              error= '';

            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
                content: Text('Incorrect Choice!'),
                duration: const Duration(milliseconds: 800),
                width: 280.0, // Width of the SnackBar.
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, // Inner padding for SnackBar content.
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          },
          child: Text(generateRandomDigits('097'), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
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
            'Practice Test',
            style: TextStyle(color: Colors.white,fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              if (buttonState == 'End') {
                setState(() {
                  buttonState = 'InTest';
                });
                startPractice();
              }else{
                setState(() {
                  error = 'Finish the practice first';
                });
              }
            },
            icon: Icon(
              Icons.redo,
              color: Colors.pink[50],
            ),
            label: const Padding(
              padding:  EdgeInsets.only(right:8.0),
              child: Text('Redo',
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
                'Choose the matching digits in the noise.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Make the choice when prompted.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'You will only hear one set of 3 digits for this practice.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 20.0, width: double.infinity),
            ElevatedButton(
              onPressed: buttonState == 'InTest'? null : () {
                if (buttonState == 'Start') {
                  setState(() {
                    buttonState = 'InTest';
                    buttonVisible = true;
                  });
                  startPractice();
                } else if (buttonState == 'InTest') {
                  setState(() {
                    error = '';
                  });

                }
                else if (buttonState=='End'){

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Test2()),
                  );
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
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}

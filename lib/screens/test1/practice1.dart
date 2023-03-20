import 'package:audioapp/screens/test1/test1.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class Practice1 extends StatefulWidget {
  const Practice1({Key? key}) : super(key: key);

  @override
  State<Practice1> createState() => _Practice1State();
}

class _Practice1State extends State<Practice1> {
  String buttonState = 'Start';
  // String buttonState = 'End';
  Map<String, String> textDict = {
    'Start': 'Start',
    'InTest': 'I heard it!',
    'End': 'Go to Test',
  };
  bool playing = false;
  String error ="";
  final player = AudioPlayer();

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  beep(int frequency) async{
    setState(() {
      playing = true;
    });

    for (int i = 0; i < 3; i++) {
      await player.play(AssetSource("audio/$frequency.wav"));
      await player.seek(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 200));
      await player.stop();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      playing = false;
    });

  }

  startPractice() async {
    await beep(500);
    await Future.delayed(const Duration(milliseconds: 3000));
    await beep(1000);
    setState(() {
      buttonState = 'End';
    });
    await _endPracticeDialogBuilder(context);


  }

  bool clickHandler() {
    if (playing) {

      print("indeed playing");
      return true;
    } else {
      setState(() {
        playing = false;
      });
      print("not playing");
      return false;
    }
  }

  Future<void> _endPracticeDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congrats!'),
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
                  MaterialPageRoute(builder: (context) => const Test1()),
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
            const SizedBox(height: 10.0, width: double.infinity),

            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'A sequence of 3 consecutive beeps will be played.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Click the button once during the beeps.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'You will only hear two sets for this practice.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 20.0, width: double.infinity),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  textDict[buttonState]!,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                if (buttonState == 'Start') {
                  setState(() {
                    buttonState = 'InTest';
                  });
                  startPractice();
                } else if (buttonState == 'InTest') {
                  setState(() {
                    error = '';
                  });
                  String msg = '';
                  if(clickHandler()){
                    msg = 'Nice Catch!';
                  }else{
                    msg = 'You missed it!';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Code to execute.
                        },
                      ),
                      content: Text(msg),
                      duration: const Duration(milliseconds: 200),
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


                }
                else if (buttonState=='End'){

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Test1()),
                  );
                }
              },
            ),
            const SizedBox(height: 20.0, width: double.infinity),
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

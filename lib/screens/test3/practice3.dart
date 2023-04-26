import 'package:audioapp/screens/test3/test3.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';

class Practice3 extends StatefulWidget {
  const Practice3({Key? key}) : super(key: key);

  @override
  State<Practice3> createState() => _Practice3State();
}



class _Practice3State extends State<Practice3> {
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


  HeadsetState headPhoneState = HeadsetState.DISCONNECT;

  @override
  initState() {
    super.initState();

    HeadsetEvent headsetPlugin = new HeadsetEvent();
    headsetPlugin.getCurrentState.then((_val){
      setState(() {
        headPhoneState = _val!;
      });
    });
    headsetPlugin.setListener((_val) {
      setState(() {
        headPhoneState = _val;
      });
    });

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
    await player.play(AssetSource("audio/stereo_signal_1000.mp3"));
  }

  startPractice() async {
    print(headPhoneState);

    if (headPhoneState == HeadsetState.CONNECT) {
      await playAudio();
      setState(() {
        buttonState = 'InTest';
        buttonVisible = true;
        buttons = generateButtons();
        error = '';
      });
    } else {
      setState(() {
        error = "Please connect your headphone";
      });
    }

    // print(buttonVisible);
    // print(buttons);
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
                  MaterialPageRoute(builder: (context) => const Test3()),
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
          child: Text('Different', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
          child: Text('Same', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
    ];
    // buttons.shuffle();
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
                'In this practice, you will hear the following sound. ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Left ear: Pure tone - 500Hz',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Right ear: Pure tone - 500Hz or Tone with changing frequency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 10.0, width: double.infinity),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Decide whether the sound is the same in both ears or different.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 20.0, width: double.infinity),
            ElevatedButton(
              onPressed: buttonState == 'InTest'? null : () {
                if (buttonState == 'Start') {
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
                        builder: (context) => const Test3()),
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

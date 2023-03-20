import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:audioapp/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/appUser.dart';

class Test1 extends StatefulWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  String buttonState = 'Start';
  Map<String, String> textDict = {
    'Start': 'Start Practice',
    'InTest': 'I heard it!',
    'End': 'Start Test',
  };
  bool playing = false;
  bool heard = false;
  bool pause = false;
  double vol = 0;
  int frequency = 0;
  double progress = 0;
  int ear = 0;

  // left ear 0, right ear 1
  Map<String, dynamic> data = {
    '500': [0.0, 0.0],
    '1000': [0.0, 0.0],
    '2000': [0.0, 0.0],
    '3000': [0.0, 0.0],
    '4000': [0.0, 0.0],
    '6000': [0.0, 0.0],
    '8000': [0.0, 0.0]
  };

  final player = AudioPlayer();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    PerfectVolumeControl.hideUI = false;
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => yourFunction(context));
  }

  @override
  dispose() {
    super.dispose();
    print('stop');
    player.dispose();
  }

  beep(int f, double v) async {
    setState(() {
      playing = true;
      frequency = f;
      vol = v;
    });
    PerfectVolumeControl.setVolume(v);
    for (int i = 0; i < 3; i++) {
      if (mounted) {
        while (pause) {
          print('paused');
          await Future.delayed(const Duration(milliseconds: 500));
        }

        await player.play(AssetSource("audio/$f.wav"));
        await player.seek(const Duration(milliseconds: 500));
        await Future.delayed(const Duration(milliseconds: 200));
        await player.stop();
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        player.dispose();
      }
    }

    setState(() {
      playing = false;
    });
  }

  startPractice() async {
    List<int> frequencies = [500, 1000, 2000, 3000, 4000, 6000, 8000];

    // List<int> frequencies = [500, 1000];
    List<double> vols = [0.02, 0.03, 0.04];
    for (int i = 0; i < frequencies.length; i++) {
      print('frequency ${frequencies[i]}');
      setState(() {
        progress = i / frequencies.length;
      });
      for (int j = 0; j < vols.length; j++) {
        if (!mounted) {
          return;
        }
        if (heard) {
          print('breaking');
          break;
        } else {
          print('beep -> frequency: ${frequencies[i]}, vol: ${vols[j]}');
          await beep(frequencies[i], vols[j]);
          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
      setState(() {
        heard = false;
      });
    }

    setState(() {
      buttonState = 'End';
    });
    print('end');
    var val = await submitData();
    print('val: $val');
    await _endDialogBuilder(context);
  }

  submitData() async {
    setState(() {
      data['time'] = DateTime.now().millisecondsSinceEpoch.toString();
    });
    print(data);
    final appUser = Provider.of<AppUser?>(context,listen: false);
    await  DatabaseService(uid: appUser!.uid).updateUserAudioData('test1',data);
  }

  bool clickHandler() {
    if (playing) {
      setState(() {
        heard = true;
      });
      print('heard-> vol: $vol, frequency: $frequency');

      setState(() {
        data['$frequency']![ear] = vol;
      });
      return true;
    } else {
      setState(() {
        playing = false;
      });
      print("not playing");
      return false;
    }
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
                GoRouter.of(context).go('/profile');
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _cancelDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Test?'),
          content: const Text('You can resume the test or return Home.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Resume'),
              onPressed: () {
                setState(() {
                  pause = false;
                });

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Stop'),
              onPressed: () {
                setState(() {
                  pause = false;
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
          'Test',

          style: TextStyle(color: Colors.white,fontSize: 20.0 ,fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              setState(() {
                pause = true;
              });
              await _cancelDialogBuilder(context);
            },
            icon: const Icon(
              Icons.pause,
              color: Colors.black,
            ),
            label: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text('Pause',
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: progress,
                    ),
                    builder: (BuildContext context, double value, _) =>
                        LinearProgressIndicator(
                      value: value,
                      minHeight: 10.0,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Test started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Only clicking once during the beeps.',
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
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      if (buttonState == 'Start') {
                        setState(() {
                          buttonState = 'InTest';
                        });
                        startPractice();
                      } else if (buttonState == 'InTest') {
                        String msg = '';
                        if (clickHandler()) {
                          msg = 'Nice Catch!';
                        } else {
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
                            width: 280.0,
                            // Width of the SnackBar.
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  8.0, // Inner padding for SnackBar content.
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      } else if (buttonState == 'End') {
                        print('end');
                      }
                    },
                  ),
                  const SizedBox(height: 20.0, width: double.infinity),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

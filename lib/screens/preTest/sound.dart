import 'dart:async';

import 'package:audioapp/screens/test1/practice1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

import '../test2/practice2.dart';
import '../test3/practice3.dart';


class Sound extends StatefulWidget {
  final String test;

  const Sound({Key? key, required this.test}) : super(key: key);

  @override
  State<Sound> createState() => _SoundState();
}

class _SoundState extends State<Sound> {

  double _value = 0.5;

  final player = AudioPlayer();


  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {

    PerfectVolumeControl.hideUI = false;

    PerfectVolumeControl.getVolume().then((volume) {

      setState(() {
        _value = volume;
      });
    });


    // Bind listener
    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        _value = volume;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    playAudio () async {

      await player.play(AssetSource("audio/beep.mp3"));
    };


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[600],
          scrolledUnderElevation: 4.0,
          elevation: 0,
          title: const Text(
          'Pre Test Check',
          style: TextStyle(color: Colors.white,fontSize: 20.0, fontWeight: FontWeight.bold),
      )),
        body: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0, width: double.infinity),

              const Padding(
                padding: EdgeInsets.only(left: 30.0,right: 30.0),
                child: Text(
                      'Adjust the sound level to your comfort',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),

                  ),
              ),

              const SizedBox(height: 50.0, width: double.infinity),

              Slider(
                min: 0.0,
                max: 1.0,
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  PerfectVolumeControl.setVolume(_value);
                },
                onChangeEnd: (value) {
                  setState(() {
                    _value = value;
                  });

                  playAudio();

                },
              ),


              const SizedBox(height: 100.0, width: double.infinity),

              ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      if (widget.test == 'test1'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Practice1()),
                        );
                      }
                      else if (widget.test == 'test2'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Practice2()),
                        );
                      }
                      else if (widget.test == 'test3'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Practice3()),
                        );
                      }
                      else{
                        debugPrint('test error! Going to /');
                        GoRouter.of(context).go('/');
                      }

                    },
                  ),
              const SizedBox(height: 20.0, width: double.infinity),


            ],
          ),
        ),

    );
  }
}

import 'package:audioapp/screens/preTest/sound.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Quiet extends StatelessWidget {
  final String test;
  const Quiet({Key? key,required this.test}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Find a quiet place',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100.0, width: double.infinity),

            Image.asset(
              'assets/quiet.png',
              width: 300,
              height: 300,

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
                    // debugPrint(test);
                    // GoRouter.of(context).go('/home');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Sound(test: test)),
                    );
                  },
                ),
            const SizedBox(height: 20.0, width: double.infinity),


          ],
        ),
      ),
    );
  }
}

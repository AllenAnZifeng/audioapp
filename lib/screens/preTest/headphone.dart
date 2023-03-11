import 'package:audioapp/screens/preTest/quiet.dart';
import 'package:flutter/material.dart';

class HeadPhone extends StatelessWidget {
  final String test;
  const HeadPhone({Key? key, required this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        scrolledUnderElevation: 4.0,
        elevation: 0,
        title: const Text(
        'Pre Test Check',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    )),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0, width: double.infinity),
            const Text(
              'Please Wear Headphones',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100.0, width: double.infinity),

            Image.asset(
              'assets/headphone.png',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Quiet(test: test)),
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

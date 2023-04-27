import 'package:audioapp/screens/preTest/headphone.dart';
import 'package:audioapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:audioapp/services/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioapp/models/brew.dart';

import '../../models/appUser.dart';
import '../authenticate/authHome.dart';
import '../profile/profile.dart';

class Home extends StatefulWidget {
  // final Function toggleView;
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  String test = "";


  @override
  Widget build(BuildContext context) {

    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);

    // print('Home appUser: $appUser');
    // print('Home appUserData: $appUserData');

    if (appUser == null) {
      return  const AuthHome();
    }


    tapHandler(String test) {
      debugPrint('tapped');
      debugPrint(test);
      setState(() => test = test);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HeadPhone(test: test)));
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService(uid: appUser.uid).getBrews,
      initialData: null,

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purple[600],
          scrolledUnderElevation: 4.0,
          elevation: 0,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white,fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.pink[50],
              ),
              label: const Text('logout',
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: () => {
               GoRouter.of(context).go('/profile/0')
              },

              icon: Icon(
                Icons.person,
                color: Colors.pink[50],
              ),
              label: const Padding(
                padding: EdgeInsets.only(right:8.0),
                child: Text('Profile',
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
              SizedBox(height: 20.0, width: double.infinity),
              const Text(
                'Select a Test',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Card(
                margin: const EdgeInsets.only(left: 30, right: 30),
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    tapHandler("test1");
                  },
                  child: SizedBox(
                    width: double.infinity,

                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              'assets/test1.png',
                              width: 80,
                              height: 80,

                            ),
                          )
                          ,
                           Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text('Pure Tone Threshold Test',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('This test measures the lowest volume of sound you can hear at different frequencies.',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Card(
                margin: const EdgeInsets.only(left: 30, right: 30),
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    tapHandler("test2");
                  },
                  child: SizedBox(
                    width: double.infinity,

                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              'assets/test2.png',
                              width: 80,
                              height: 80,

                            ),
                          )
                          ,
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text('Masked Noise Test',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('This test measures the ability you can hear sound with a moderate  background noise.',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Card(
                margin: const EdgeInsets.only(left: 30, right: 30),
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    tapHandler("test3");
                  },
                  child: SizedBox(
                    width: double.infinity,

                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              'assets/test3.png',
                              width: 80,
                              height: 80,

                            ),
                          )
                          ,
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text('Temporal Processing Test',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('This test measures your ability to detect frequency modulated signal as a measure of temporal processing capabilities.',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

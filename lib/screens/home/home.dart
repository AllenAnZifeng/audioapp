import 'package:audioapp/screens/home/setting_form.dart';
import 'package:audioapp/screens/preTest/headphone.dart';
import 'package:audioapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:audioapp/services/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioapp/screens/home/brew_list.dart';
import 'package:audioapp/models/brew.dart';

import '../../models/appUser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  String test = "";

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SettingForm();
          });
    }

    final appUser = Provider.of<AppUser?>(context);

    tapHandler(String test) {
      debugPrint('tapped');
      debugPrint(test);
      setState(() => test = test);
      // GoRouter.of(context).go('/preTestHeadPhone');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HeadPhone(test: test)));
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService(uid: appUser!.uid).getBrews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purple[600],
          scrolledUnderElevation: 4.0,
          elevation: 0,
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
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
              onPressed: () => _showSettingsPanel(),
              icon: const Icon(
                Icons.person,
                color: Colors.black,
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
                                    child: Text('Spatial Sound Test',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('This test measures your ability to hear sounds coming from different spatial directions.',
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

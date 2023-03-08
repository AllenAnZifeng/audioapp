import 'package:audioapp/screens/home/setting_form.dart';
import 'package:audioapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:audioapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioapp/screens/home/brew_list.dart';
import 'package:audioapp/models/brew.dart';

import '../../models/appUser.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

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

    return StreamProvider<List<Brew>?>.value(
      value:DatabaseService(uid:appUser!.uid).getBrews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0,
          title: const Text('Home'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: () =>_showSettingsPanel(),
              icon: const Icon(Icons.settings),
              label: const Text('settings'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BrewList()),
      ),
    );
  }
}

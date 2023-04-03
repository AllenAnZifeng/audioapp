import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:audioapp/screens/preTest/profileInit.dart';
import 'package:audioapp/screens/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioapp/models/appUser.dart';

import '../services/auth.dart';
import '../services/database.dart';
import '../shared/loading.dart';
import 'authenticate/authHome.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // bool showHome = true;
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    if (appUser == null) {
      return const AuthHome();
    } else {
      return StreamProvider<AppUserData?>.value(
        value: DatabaseService(uid: appUser.uid).getUserData,
        initialData: null,
        builder: (context, widget) {

          final appUserData = Provider.of<AppUserData?>(context);

          if (appUserData != null ) {
            if (appUserData.gender != '' && appUserData.dob != '') {

                return  Home();

            } else {
              return const ProfileInit();
            }
          } else {
            return Loading();
          }

        },
      );
    }
  }
}

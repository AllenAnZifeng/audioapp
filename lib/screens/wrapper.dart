import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:audioapp/screens/preTest/profileInit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioapp/models/appUser.dart';

import '../services/database.dart';
import '../shared/loading.dart';
import 'authenticate/authHome.dart';

class Wrapper extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);


    if (appUser == null) {

      return AuthHome();
    } else {

      return StreamBuilder<AppUserData>(
        stream: DatabaseService(uid: appUser.uid).getUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUserData userData = snapshot.data!;
           if (userData.gender!=''&&userData.dob!=''){
             return Home();
           } else {
             return ProfileInit();
           }
          } else if (snapshot.hasError) {
            print('error');
            print(snapshot.error);
            List<Widget> children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
            // return AuthHome();
          } else {
            return Loading();
          }

        },
      );
    }
  }
}

import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioapp/models/appUser.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    if (appUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}

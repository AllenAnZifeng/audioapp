import 'package:audioapp/screens/authenticate/register.dart';
import 'package:audioapp/screens/authenticate/signIn.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else {
      return Container(
        child: Register(toggleView: toggleView),
      );
    }

  }
}

import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/appUser.dart';
import '../../services/auth.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        toolbarHeight: 100,
        title: Container(
          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: const Center(
              child: Text(
            'Hearing Pro Lab',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          Container(
              child: Image.asset(
            'assets/home_pic.png',
            width: 300,
            height: 300,
          )),
          const SizedBox(height: 20.0),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              height: 100,
              child: ElevatedButton(
                child: const Text(
                  'Sign in with Hearing Pro',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // GoRouter.of(context).go('/authenticate');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Authenticate()),
                  );
                },
              )),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              height: 100,
              child: ElevatedButton(
                child: const Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final AuthService _auth = AuthService();
                  AppUser? result = await _auth.signInWithGoogle();
                  if (result == null) {
                    print('error signing in');
                  } else {
                    print('signed in');
                    print(result.uid);

                  }
                },
              )),
        ],
      ),
    );
  }
}

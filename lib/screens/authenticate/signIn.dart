import 'package:audioapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  String email ="";
  String password ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign in to AudioApp'),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
            label: const Text('Register'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ElevatedButton(
              child: const Text('Guest Sign in'),
              onPressed: () async {
                dynamic result = await _auth.signInAnonymously();
                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result.uid);
                }
              },
            )
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          //   child: ElevatedButton(
          //     child: const Text('Sign in with Google'),
          //     onPressed: () async {
          //       // dynamic result = await _auth.signInWithGoogle();
          //       // if (result == null) {
          //       //   print('error signing in');
          //       // } else {
          //       //   print('signed in');
          //       //   print(result.uid);
          //       // }
          //     },
          //   )
          // ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: const Text('Sign in with Email and Password'),
                    onPressed: () async {
                      print(email);
                      print(password);

                      // dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      // if (result == null) {
                      //   print('error signing in');
                      // } else {
                      //   print('signed in');
                      //   print(result.uid);
                      // }
                    },
                  ),
                ],
              ),
              )
            )
        ],
      ),
    );
  }
}

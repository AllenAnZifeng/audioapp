import 'package:audioapp/models/appUser.dart';
import 'package:audioapp/services/auth.dart';
import 'package:audioapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/constants.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email ="";
  String password ="";
  String error ="";



  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                AppUser? result = await _auth.signInAnonymously();
                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result.uid);
                }
              },
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                    decoration:textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: const Text('Sign in with Email and Password'),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() => loading = true);
                        AppUser? result = await _auth.signinWithEmailAndPassword(
                            email, password);
                        setState(() => loading = false);
                        if (result == null) {
                          setState(() {
                            error = 'Sign In Error!';
                          });
                        } else {
                          print('signed in');
                          if (context.mounted){
                            // GoRouter.of(context).go('/');
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
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

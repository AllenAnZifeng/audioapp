import 'package:audioapp/services/auth.dart';
import 'package:audioapp/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../models/appUser.dart';
import '../../shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error ="";

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign up to AudioApp'),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
            label: const Text('Sign in'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text('Sign up with Email and Password'),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          AppUser? result = await _auth.registerWithEmailAndPassword(
                              email, password);
                          setState(() => loading = false);
                          if (result == null) {
                            setState(() {
                              error = 'Registration Error!';
                            });
                          } else {
                            setState(() {
                              error = 'Registration Successful!';
                            });
                            debugPrint('registered');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:audioapp/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
          ),],
      ),
      body: Column(
        children: [
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
                      child: const Text('Sign up with Email and Password'),
                      onPressed: () async {
                        print(email);
                        print(password);
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

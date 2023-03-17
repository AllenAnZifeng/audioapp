// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:audioapp/screens/preTest/headphone.dart';
import 'package:audioapp/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:audioapp/services/auth.dart';
import 'package:audioapp/models/appUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) =>  Wrapper(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => Home(),
      ),

    ],
  );

  @override
  Widget build(BuildContext context) {
      return StreamProvider<AppUser?>.value(
        value: AuthService().getUser,
        initialData: null,
        child: MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: _router,
        ),
      );
  }
}

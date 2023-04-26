// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:audioapp/screens/authenticate/authenticate.dart';
import 'package:audioapp/screens/home/home.dart';
import 'package:audioapp/screens/preTest/headphone.dart';
import 'package:audioapp/screens/profile/profile.dart';
import 'package:audioapp/screens/wrapper.dart';
import 'package:audioapp/services/database.dart';
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
        builder: (context, state) => Wrapper(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: "/profile/:index",
        builder: (context, state) => Profile(
          initIndex: int.parse(state.params['index']!),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          StreamProvider<AppUser?>.value(
            value: AuthService().getUser,
            initialData: null,
          ),
          ProxyProvider<AppUser?,DatabaseService>(
            update: (_, appUser, __) =>  DatabaseService(uid: appUser?.uid ?? ''),
          ),
          StreamProvider<AppUserData?>(
            create: (context) => Provider.of<DatabaseService>(context,listen: false).getUserData,
            initialData: null,
          ),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: _router,
        ));
  }
}

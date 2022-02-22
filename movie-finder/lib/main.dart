import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'services.dart';
import 'settings.dart';
import 'package:url_strategy/url_strategy.dart'; // remove # marker in URL

// import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  setPathUrlStrategy();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'The Movie Finder',
      theme: ThemeData(
        fontFamily: 'SanFrancisco',
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyAccPage(),
        '/best': (context) => MyServicesPage(),
        '/coming': (context) => MySettingsPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:dashboard_tmp/widgets/pop_snackbar.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final bool displayRoutes;
  final double barHeight = 80.0;

  const GradientAppBar(this.title, this.displayRoutes, {Key? key})
      : super(key: key);

  Widget getTab(BuildContext context, String title, String route) {
    TextDecoration? deco;

    if (ModalRoute.of(context)?.settings.name == route) {
      deco = TextDecoration.underline;
    } else if (!displayRoutes) {
      return Container();
    }
    return TextButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name == route) {
          return;
        }
        if (ModalRoute.of(context)?.settings.name != '/' && route == '/') {
          Navigator.pop(context);
        } else if (ModalRoute.of(context)?.settings.name != '/' &&
            route != '/') {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(title,
          style: TextStyle(
              decoration: deco,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1)),
    );
  }

  Future<void> signOutGoogle() async {
    // await Firebase.initializeApp();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final TwitterLogin twitterLogin = new TwitterLogin(
        apiKey: 'WELF63e9EIewehbDlGrio2abg',
        apiSecretKey: 'OqxOCCwMaHx3XBA2hzfYVt4IrzC5P1SnzSU6OGzLPRpvbZWKYX',
        redirectURI:
            'https://dashboard-tek-28737.firebaseapp.com/__/auth/handler');

    await googleSignIn.signOut();
    await _auth.signOut();
    // await twitterLogin.

    // twitterLogin.

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    // uid = null;
    // userEmail = null;
    // name = null;
    // imageUrl = null;

    print("User Sign Out");
  }

  askAreYouSure(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        popSnackBar(context, 'Logging off...', Colors.orange);
        await signOutGoogle();
        Navigator.pushNamed(context, "/login");
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Leaving..."),
      content: Text("Are you sure you want to leave ?"),
      actions: [
        yesButton,
        cancelButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _getIcon(context) {
    Color home = Colors.white;
    String? route = ModalRoute.of(context)?.settings.name;
    if (route == "/") {      
      home = Colors.transparent;
    }
    return IconButton(
            icon: const Icon(Icons.home),
            color: home,
            hoverColor: Colors.red,
            iconSize: 30,
            onPressed: () {
              if (route != "/")
                Navigator.pop(context);
            });
  }

  Widget getAllTabs(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: (displayRoutes) ? WrapAlignment.start : WrapAlignment.end,
        children: [
          getTab(context, 'EN CE MOMENT', '/'),
          SizedBox(width: 40),
          getTab(context, 'POPULAIRE', '/best'),
          SizedBox(width: 40),
          getTab(context, 'A VENIR', '/coming'),
          SizedBox(width: 40),
          _getIcon(context),
          SizedBox(width: 20),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: TextButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != "/") {
                  Navigator.pop(context);
                }
              },
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SanFrancisco',
                ),
              ),
            ),
          ),
          Flexible(
              child: Container(
                  alignment: Alignment.centerRight, child: getAllTabs(context)))
        ],
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF175B70)],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}

import 'dart:convert';

import 'package:dashboard_tmp/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_x/widgets/button/button.dart';
import 'package:flutter_theme_x/widgets/text/text.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'widgets/network_conf.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

// users import
import 'ActiveUser.dart' as acUsr;

var usr = acUsr.userActive!;

class SecLog {
  html.WindowBase? _popupWin;

  // TWITCH SECTION //

  String? _twitchToken;
  var twitch_client_id = "pk074tf0x8elewmoxe0mfygg58m7v7";
  var twitch_secret_tmp = "g4k9mazflmyb5nsl5zfs7qgka1qbi3";
  var twitch_app_access_token =
      "ub49lhqgohb4r0kee4ph0alztr186p"; // mine. this one is valid for 60 days. changes on the user

  Future tLogin(String data) async {
    final receivedUri = Uri.parse(data);
    _twitchToken = receivedUri.fragment
        .split('&')
        .firstWhere((element) => element.startsWith('access_token='))
        .substring('access_token='.length);
    await usr.updateUserData({'twitch.api_key': _twitchToken});

    if (_popupWin != null) {
      _popupWin!.close();
      _popupWin = null;
    }
  }

  Future twitchPopUp() async {
    final currentUri = Uri.base;
    final redirectURI = Uri(
        host: currentUri.host,
        scheme: currentUri.scheme,
        port: currentUri.port,
        path: '/static.html');
    final authUrl =
        "https://id.twitch.tv/oauth2/authorize?response_type=token&client_id=$twitch_client_id&redirect_uri=$redirectURI&scope=viewing_activity_read";

    _popupWin = html.window
        .open(authUrl, 'Twitch Auth', 'height=600,width=800,scrollbars=yes');

    //listner when the windows is open
    html.window.onMessage.listen((event) async {
      print("we're listening");

      /// If the event contains the token it means the user is authenticated.
      if (event.data.toString().contains('access_token=')) {
        await tLogin(event.data);
      }
    });
    await checkEveryOauth('twitch');
  }

  // COINBASE SECTION //

  String? _btcToken;
  var cbase_client_id =
      "3a678f52ba7f132c1608c7234c02a76c4ee3a35898b4f203850c428a27f59729";
  var cbase_client_secret =
      "6159cef61db8bcc71fa6acd099758377092753d668980ebb7839aee9f9bd5a94";

  Future cbaseLogin(String data) async {
    print("cbaseLogin");
    final receivedUri = Uri.parse(data);

    receivedUri.queryParameters.forEach((key, value) async {
      print("$key: $value");
      try {
        if (key == 'code') {
          final response = await http
              .post(Uri.parse('https://api.coinbase.com/oauth/token'), body: {
            'grant_type': 'authorization_code',
            'code': value,
            'client_id': cbase_client_id,
            'client_secret': cbase_client_secret,
            'redirect_uri': 'http://localhost:7878/static.html',
          });
          final jsonResponse = json.decode(response.body);
          _btcToken = jsonResponse['access_token'];
          await usr.updateUserData({'btc.api_key': _btcToken});
        }
      } catch (e) {
        print(e);
      }
    });

    if (_popupWin != null) {
      _popupWin!.close();
      _popupWin = null;
    }
  }

  Future cbasePopUp() async {
    final currentUri = Uri.base;
    final redirectURI = Uri(
        host: currentUri.host,
        scheme: currentUri.scheme,
        port: currentUri.port,
        path: '/static.html');
    //var link =
    //"https://www.coinbase.com/oauth/authorize?client_id=3a678f52ba7f132c1608c7234c02a76c4ee3a35898b4f203850c428a27f59729&redirect_uri=http%3A%2F%2Flocalhost%3A7878%2Fstatic.html&response_type=code&scope=wallet%3Auser%3Aread";
    final authUrl =
        "https://coinbase.com/oauth/authorize?response_type=code&client_id=$cbase_client_id&redirect_uri=$redirectURI&scope=wallet:user:read,wallet:accounts:read";

    _popupWin = html.window
        .open(authUrl, 'Coinbase Auth', 'height=600,width=800,scrollbars=yes');

    html.window.onMessage.listen((event) async {
      print("we're listening");

      /// If the event contains the token it means the user is authenticated.
      if (event.data.toString().contains('code=')) {
        print("a code is found..." + event.data.toString());
        await cbaseLogin(event.data);
      }
    });
    await checkEveryOauth('btc');
  }

  Future checkEveryOauth(String serviceName) async {
    print("checkEveryOauth");
    acUsr.data = await usr.getUserDataMap();
    switch (serviceName) {
      case "twitch":
        if (acUsr.data['twitch']['api_key'] == "") {
          usr.updateUserData({"twitch.isLogged": false});
          break;
        } else {
          try {
            var response = await http.get(
                Uri.parse("https://api.twitch.tv/helix/users?login=twitchdev"),
                headers: {
                  "Client-ID": twitch_client_id,
                  "Authorization": "Bearer ${acUsr.data['twitch']['api_key']}"
                });
            if (response.statusCode == 200) {
              usr.updateUserData({"twitch.isLogged": true});
            } else {
              usr.updateUserData({"twitch.isLogged": false});
              usr.updateUserData({"twitch.enabled": false});
            }
          } catch (e) {
            usr.updateUserData({"twitch.isLogged": false});
            usr.updateUserData({"twitch.enabled": false});
          }
        }
        break;

      case "btc":
        if (acUsr.data['btc']['api_key'] == "") {
          usr.updateUserData({"btc.isLogged": false});
          usr.updateUserData({"btc.enabled": false});
          break;
        } else {
          try {
            var response = await http
                .get(Uri.parse("https://api.coinbase.com/v2/user"), headers: {
              "Authorization": "Bearer ${acUsr.data['btc']['api_key']}"
            });
            if (response.statusCode == 200) {
              usr.updateUserData({"btc.isLogged": true});
            } else {
              usr.updateUserData({"btc.isLogged": false});
              usr.updateUserData({"btc.enabled": false});
            }
          } catch (e) {
            usr.updateUserData({"btc.isLogged": false});
            usr.updateUserData({"btc.enabled": false});
          }
        }
        break;
    }
  }

  // make me a function that take a service name as an argument and return the proper oauth popup
  Future multiLogin(String serviceName) async {
    switch (serviceName) {
      case "twitch":
        await twitchPopUp();
        break;
      case "btc":
        await cbasePopUp();
        break;
      default:
    }
  }
}

class ApiWrappers {
  void getTwitchChannel(String _searchTerms) async {}
}

class MyServicesPage extends StatefulWidget {
  MyServicesPage({Key? key}) : super(key: key);

  @override
  _MyServicesPage createState() => _MyServicesPage();
}

class _MyServicesPage extends State<MyServicesPage> {
  // var usr;
  late acUsr.UserActive usr = acUsr.userActive!;
  var data2;
  late NetworkConf _ytb;
  late NetworkConf _twitch;
  late NetworkConf _steam;
  late NetworkConf _btc;
  late NetworkConf _weather;
  Future<bool>? _data;
  bool ytb_enabled = false;
  bool ytb_logged = false;

  Future<bool> _fetchDataDebug() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      // debugPrint("fetchData in service");
      data2 = await usr.getUserDataMap();
      // debugPrint("User mail after fetch data ${usr.email}");
      acUsr.userActive = usr;
      // debugPrint("User mail after user active ${usr.email}");
      acUsr.data = data2;

      _ytb = NetworkConf("Youtube", "youtube", acUsr.data['youtube']['enabled'],
          acUsr.data['youtube']['isLogged']); // name, isActive, isLoged
      _twitch = NetworkConf("Twitch", "twitch", acUsr.data['twitch']['enabled'],
          acUsr.data['twitch']['isLogged']);
      _steam = NetworkConf("Steam", "steam", acUsr.data['steam']['enabled'],
          acUsr.data['steam']['isLogged']);
      _btc = NetworkConf("Coinbase", "btc", acUsr.data['btc']['enabled'],
          acUsr.data['btc']['isLogged']);
      _weather = NetworkConf(
          "Weather",
          "weather",
          acUsr.data['weather']['enabled'],
          acUsr.data['weather']['isLogged']); // always logged

    } catch (e) {
      print("Error : $e");
      return false;
    }
    return true;
  }

  SecLog? _secLog = SecLog();

  void initState() {
    super.initState();
    _data = _fetchDataDebug();
    _secLog!.checkEveryOauth('twitch');
    _secLog!.checkEveryOauth('btc');
  }

  Widget getLoginButton(NetworkConf conf) {
    return Container(
        height: 55,
        width: 125,
        child: FTxButton.medium(
          backgroundColor: (conf.getLogged()) ? Colors.green : Colors.blue,
          borderRadiusAll: 50,
          onPressed: () async {
            try {
              print("Checking if an api is available for ${conf.getId()} ...");
              await _secLog!.checkEveryOauth(conf.getId());
              acUsr.data = await usr.getUserDataMap();
            } catch (e) {
              print(e);
            }

            if (acUsr.data[conf.getId()]['isLogged'] == false) {
              print("Opening popup ...");
              await _secLog!.multiLogin(conf.getId());
              print("popup closed");
              acUsr.data = await usr.getUserDataMap();
            }

            setState(() {
              if (acUsr.data[conf.getId()]['isLogged'] == true) {
                // conf.changeLogged();
                conf.setLogged(true);
              }
            });

            // Navigator.pushNamed(context, "/services");
          },
          child: (conf.getLogged()
              ? Icon(Icons.assignment_turned_in, color: Colors.white)
              : FTxText(
                  (conf.getLogged())
                      ? "Connected"
                      : "Login", // check the variable "isActive" in the db for the conf
                  color: Colors.white)),
        ));
  }

  Future changeBool(String who, String param, bool changeTo) async {
    try {
      print("request time");
      await usr.updateUserData({who + "." + param: changeTo});
      print('request is succes');
      // html.window.location.reload();
      // Navigator.pushNamed(context, "/services");
    } catch (e) {
      print(e);
      // print("the bool val is :${acUsr.data[conf.getId() + ".enabled"]}");
    }
  }

  Widget getActiveSwitch(NetworkConf conf) {
    return Container(
        height: 64,
        color: Colors.white,
        child: FlutterSwitch(
            width: 125.0,
            height: 55.0,
            valueFontSize: 25.0,
            toggleSize: 45.0,
            // activeColor: (conf.getName() == "Weather") ? Colors.green: Colors.blue,
            borderRadius: 30.0,
            padding: 8.0,
            // showOnOff: true,
            value: conf.getActive(),
            onToggle: (val) async {
              if (conf.getLogged() == true) {
                setState(() {
                  conf.changeActive();
                });
                await changeBool(conf.getId(), "enabled", conf.getActive());
                // html.window.location.reload();
              }
            }));
  }

  static const rowSpacer = TableRow(children: [
    SizedBox(
      height: 20,
    ),
    SizedBox(
      height: 20,
    )
  ]);

  Padding getSocialTable(BuildContext context) {
    final double scrWidth = 372;

    return Padding(
      padding: const EdgeInsets.all(150.0),
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(scrWidth / 2),
          1: FixedColumnWidth(scrWidth),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: FTxText.h5(this._ytb.getName() + " :")),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // getLoginButton(this._ytb),
                    getActiveSwitch(this._ytb),
                  ],
                ),
              ),
            ],
          ),
          rowSpacer,
          TableRow(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: FTxText.h5(this._twitch.getName() + " :")),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getLoginButton(this._twitch),
                    getActiveSwitch(this._twitch),
                  ],
                ),
              ),
            ],
          ),
          rowSpacer,
          TableRow(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: FTxText.h5(this._steam.getName() + " :")),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getLoginButton(this._steam),
                    getActiveSwitch(this._steam),
                  ],
                ),
              ),
            ],
          ),
          rowSpacer,
          TableRow(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: FTxText.h5(this._btc.getName() + " :")),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getLoginButton(this._btc),
                    getActiveSwitch(this._btc),
                  ],
                ),
              ),
            ],
          ),
          rowSpacer,
          TableRow(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: FTxText.h5("Weather" + " :")),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getActiveSwitch(this._weather),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        initialData: false,
        future: _data,
        builder: (context, snapshot) =>
            snapshot.hasData && snapshot.data == true
                ? _build(context)
                : LinearProgressIndicator(),
      );

  Widget _build(BuildContext context) {
    return Scaffold(
        body: ListView(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Stack(
          children: [
            const GradientAppBar('The Movie Finder', true),
          ],
        ),
        Center(child: getSocialTable(context)),
      ],
    ));
  }
}

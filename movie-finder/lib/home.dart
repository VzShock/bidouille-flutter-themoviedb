import 'dart:convert';

import 'package:dashboard_tmp/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'widgets/widget_manager.dart';
import 'widgets/movie_model.dart';
import 'ActiveUser.dart' as acUsr;
import 'services.dart' as srvc;

class MyAccPage extends StatefulWidget {
  MyAccPage({Key? key}) : super(key: key);

  @override
  _MyAccPage createState() => _MyAccPage();
}

class _MyAccPage extends State<MyAccPage> {
  Future<bool>? _data;

  final String _movieApiKey = '6691c7844e7241a1ebf50d84f4a4398e';
  final _accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NjkxYzc4NDRlNzI0MWExZWJmNTBkODRmNGE0Mzk4ZSIsInN1YiI6IjYyMGU5MmQzZDM0ZWIzMDAxYjFhNGMyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qaYem-4UFhehe-jeP0HzTv1x5CfsOgbBh-IIlK7jImk';
  // List<MovieModel> _movies = [];
  List _trendingMovies = [];
  List _topRatedMovies = [];

  final bool _weather = true;
  ScrollController _scrollController = ScrollController();
  int variableSet = 0;
  late double width;
  late double height;
  late acUsr.UserActive usr = acUsr.userActive!;
  var data2;
  var secLog = srvc.SecLog();

  @override
  void initState() {
    super.initState();
    // _loadMovies();
    _data = _fetchDataDebug();
  }

  Future<bool> _fetchDataDebug() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {

      /// this block is for identification purposes ///
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: "thegoodbash@gmail.com", password: "azerty");
      var fetchusr = userCredential.user;
      usr = acUsr.UserActive(
        fetchusr,
        acUsr.debugUid,
        "thegoodbash@gmail.com",
      );
      data2 = await usr.getUserDataMap();
      acUsr.userActive = usr;
      acUsr.data = data2;


      /// this block is going to be used to fetch out the movies

      // _trendingMovies = [];

      TMDB tmdbLogs = TMDB(ApiKeys(_movieApiKey, _accessToken),
        logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ));

      Map trendingResults = await tmdbLogs.v3.trending.getTrending();
      Map topRatedResults = await tmdbLogs.v3.movies.getTopRated();

      // this is going to be filled with data
      this._trendingMovies = trendingResults['results']; // une liste
      this._topRatedMovies = topRatedResults['results'];

      // print(_trendingMovies);
    } catch (e) {
      print("Error : $e");
      return false;
    }
    return true;
  }

  // _loadMovies() async {
  //   TMDB tmdbLogs = TMDB(ApiKeys(_movieApiKey, _accessToken),
  //   logConfig: ConfigLogger(
  //     showLogs: true,
  //     showErrorLogs: true,
  //   ));

  //   Map trendingResults = await tmdbLogs.v3.trending.getTrending();
  //   Map topRatedResults = await tmdbLogs.v3.movies.getTopRated();

  //   setState(() {
      
  //     this._trendingMovies = trendingResults['results']; // une liste

  //     this._topRatedMovies = topRatedResults['results'];
    
  //   });
  //   print(_trendingMovies);
  // }

  void knockknock() {
    // HOW TO APPEND TO THE TAB
    // usr.updateUserData({"btc.api_key": "yes"});
    // usr.appendToTab("activatedWidgetId", "steam");
    // var data = () async => await usr.getUserDataMap();
    // usr.removeFromTab("activatedWidgetId", "steam");
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              const GradientAppBar('The Movie Finder', true),
            ],
          ),
          Expanded(
            child: DragAndDropGridView(
              dragStartBehavior: DragStartBehavior.down,
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 2.02 / 3,
              ),
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) => Card(
                elevation: 2,
                child: LayoutBuilder(builder: (context, costrains) {
                  if (variableSet == 0) {
                    height = costrains.maxHeight;
                    width = costrains.maxWidth;
                    variableSet++;
                  }
                  return WidgetManager(index, this._trendingMovies, "TMP", height, width); // "TMP" = _trendingMovies[index]
                }),
              ),
              itemCount: _trendingMovies.length,
              onWillAccept: (oldIndex, newIndex) => true,
              isCustomChildWhenDragging: true,
              childWhenDragging: (pos) => Container(
                margin: const EdgeInsets.all(20.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Grey_close_x.svg/1024px-Grey_close_x.svg.png",
                  scale: 15,
                ),
              ),
              onReorder: (oldIndex, newIndex) {
                // You can also implement on your own logic on reorderable

                int indexOfFirstItem = _trendingMovies.indexOf(_trendingMovies[oldIndex]);
                int indexOfSecondItem = _trendingMovies.indexOf(_trendingMovies[newIndex]);

                if (indexOfFirstItem > indexOfSecondItem) {
                  for (int i = _trendingMovies.indexOf(_trendingMovies[oldIndex]);
                      i > _trendingMovies.indexOf(_trendingMovies[newIndex]);
                      i--) {
                    var tmp = _trendingMovies[i - 1];
                    _trendingMovies[i - 1] = _trendingMovies[i];
                    _trendingMovies[i] = tmp;
                  }
                } else {
                  for (int i = _trendingMovies.indexOf(_trendingMovies[oldIndex]);
                      i < _trendingMovies.indexOf(_trendingMovies[newIndex]);
                      i++) {
                    var tmp = _trendingMovies[i + 1];
                    _trendingMovies[i + 1] = _trendingMovies[i];
                    _trendingMovies[i] = tmp;
                  }
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: Container(
      //   height: 80.0,
      //   width: 80.0,
      //   child: FittedBox(
      //     fit: BoxFit.fill,
      //     child: SpeedDial(
      //       activeBackgroundColor: Colors.red,
      //       overlayColor: Colors.black,
      //       animatedIcon: AnimatedIcons.menu_close,
      //       children: [
      //         //remplacer les true par la variable enabled de la db ==> faire un fonction qui récupère la val selon le nom
      //         // ça sera un truc du genre data2["steam.enabled"]
      //         _getWidgetList(
      //             "youtube", Icons.music_video, data2['youtube.enabled']),
      //         _getWidgetList(
      //             "youtube-channel", Icons.people, data2['youtube.enabled']),
      //         _getWidgetList("btc", Icons.money, data2['btc.enabled']),
      //         _getWidgetList("weather", Icons.cloud, data2['weather.enabled']),
      //         _getWidgetList("steam", Icons.gamepad, data2['steam.enabled']),
      //         _getWidgetList(
      //             "twitch-channel", Icons.live_tv, data2['twitch.enabled']),
      //       ],
      //       backgroundColor: Colors.green,
      //     ),
      //   ),
      // ),
    );
  }
}

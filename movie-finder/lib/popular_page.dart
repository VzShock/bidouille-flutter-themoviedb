import 'dart:convert';

import 'package:dashboard_tmp/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'widgets/widget_manager.dart';
import 'widgets/movie_model.dart';
import 'ActiveUser.dart' as acUsr;

class MostPopularMovies extends StatefulWidget {
  MostPopularMovies({Key? key}) : super(key: key);

  @override
  _MostPopularMovies createState() => _MostPopularMovies();
}

class _MostPopularMovies extends State<MostPopularMovies> {
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
      TMDB tmdbLogs = TMDB(ApiKeys(_movieApiKey, _accessToken),
        logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ));

      Map trendingResults = await tmdbLogs.v3.movies.getTopRated();

      // this is going to be filled with data
      this._trendingMovies = trendingResults['results']; // une liste

      // print(_trendingMovies);
    } catch (e) {
      print("Error : $e");
      return false;
    }
    return true;
  }

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
              itemCount: _trendingMovies.length - 2,
              onWillAccept: (oldIndex, newIndex) => true,
              // isCustomChildWhenDragging: true,
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
      )
    );
  }
}

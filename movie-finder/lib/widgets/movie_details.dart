import 'package:dashboard_tmp/widgets/custom_app_bar.dart';
import 'package:dashboard_tmp/widgets/pop_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_theme_x/widgets/text/text.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'movie_model.dart';

class MovieDetails extends StatefulWidget {
  final MovieModel info;
  MovieDetails({Key? key, required this.info}) : super(key: key);

  MovieModel getInfo() {
    return this.info;
  }

  @override
  _MovieDetails createState() => _MovieDetails();
}

class _MovieDetails extends State<MovieDetails> {
  final Map<String, String> _themes = {
    "cloud":
        "https://files.wallpaperpass.com/2019/10/cloud%20wallpaper%20188%20-%201920x1080.jpg",
    "sunny": "https://wallpaperaccess.com/full/4880232.jpg",
    "night":
        "https://i2.wp.com/lafoliedespains.fr/wp-content/uploads/2021/09/old-black-background-grunge-texture-dark-wallpaper-blackboard-chalkboard-room-wall.jpg?ssl=1"
  };
  String _curr = "cloud";

  @override
  void initState() {
    super.initState();
    List<int> tmp_list = widget.info.genre.cast<int>();
    for(var x in tmp_list) {
      if (x == 27 || x == 18 || x == 53) { // horror thriller drama
        _curr = "night";
      } else if (x == 10402 || x == 10749 || x == 35 || x == 10751) { // comedy music romance family
        _curr = "sunny";
      } else {
        _curr = "cloud";
      }
    }
  }

  _getThemeList(String name, IconData ico) {
    return SpeedDialChild(
        backgroundColor: (this._curr == name) ? Colors.green : Colors.grey,
        onTap: () {
          setState(() {
            this._curr = name;
          });
        },
        label: name.toUpperCase(),
        child: Icon(ico));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(this._themes[this._curr]!),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  GradientAppBar(widget.info.title, false),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          height: 600,
                          width: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.getInfo().img)),
                              color: Color(0xFFFFFFFF))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                width: 115,
                                child: FTxText(widget.info.date,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10),
                                decoration:
                                    BoxDecoration(color: Color(0xFF175B70)))),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                width: 80,
                                child: FTxText(widget.info.time,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10),
                                decoration:
                                    BoxDecoration(color: Color(0xFF175B70)))),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                width: 800,
                                child: FTxText(widget.info.descr,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10),
                                decoration:
                                    BoxDecoration(color: Color(0xFF175B70)))),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

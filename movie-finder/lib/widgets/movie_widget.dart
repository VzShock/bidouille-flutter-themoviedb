import 'dart:async';
import 'package:dashboard_tmp/widgets/pop_snackbar.dart';
import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_details.dart';

class MovieWidget extends StatefulWidget {
  final double height, width;
  final String txt;
  MovieWidget(
      {Key? key, required this.txt, required this.height, required this.width})
      : super(key: key);

  @override
  _MovieWidget createState() => _MovieWidget();
}

class _MovieWidget extends State<MovieWidget> {
  MovieModel _model = MovieModel(
      id: "0",
      title: "Spider-Man: No Way Home (2021)",
      descr:
          "Après les évènements liés à l'affrontement avec Mystério, l'identité secrète de Spider-Man a été révélée. Il est poursuivi par le gouvernement américain, qui l'accuse du meurtre de Mystério, et est traqué par les médias. Cet évènement a également des conséquences terribles sur la vie de sa petite-amie M. J. et de son meilleur ami Ned. Désemparé, Peter Parker demande alors de l'aide au Docteur Strange. Ce dernier lance un sort pour que tout le monde oublie que Peter est Spider-Man. Mais les choses ne se passent pas comme prévu et cette action altère la stabilité de l'espace-temps. Cela ouvre le « Multivers », un concept terrifiant dont ils ne savent quasiment rien.",
      img:
          "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/sDYuyvhY0FUGs0MIHGKE6H8ETJZ.jpg",
      date: "15/12/2021",
      time: "2h 28m");
  late MovieDetails movie;
  Map<int, String> movie_url = {};

  @override
  void initState() {
    super.initState();
    movie = MovieDetails(info: _model);
  }

  _MovieWidget();

  _getMovieImage() {
    return NetworkImage(movie.getInfo().img);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Removed GridTile parent
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetails(info: this._model),
            ));
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: _getMovieImage()),
          gradient: LinearGradient(
              colors: [Colors.black12, Colors.black38],
              begin: FractionalOffset(0.0, -1.0),
              end: FractionalOffset(0.5, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

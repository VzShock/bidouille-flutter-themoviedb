import 'package:flutter/material.dart';
import 'package:flutter_theme_x/widgets/button/button.dart';
import 'package:flutter_theme_x/widgets/text/text.dart';
import 'movie_widget.dart';

class WidgetManager extends StatelessWidget {
  final String _txt;
  final double _height, _width;
  final int _index;
  final List _movies;

  WidgetManager(this._index, this._movies, this._txt, this._height, this._width);

  @override
  Widget build(BuildContext context) {
    switch (this._txt) {
      default:
        return MovieWidget(index: this._index, movies: this._movies,
            txt: this._txt, height: this._height, width: this._width);
    }
  }
}

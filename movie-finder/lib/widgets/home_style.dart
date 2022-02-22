import 'package:flutter/material.dart';

final GridTileDecoration = const BoxDecoration(
  gradient: LinearGradient(
      colors: [Colors.black12, Colors.black38],
      begin: FractionalOffset(0.0, -1.0),
      end: FractionalOffset(0.5, 0.5),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp),
);

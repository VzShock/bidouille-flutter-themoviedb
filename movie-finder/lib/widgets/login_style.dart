import 'package:flutter/material.dart';

const nameFieldStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w800,
  fontFamily: 'SanFrancisco',
  fontSize: 20,
);

const snackBarStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w400,
  fontFamily: 'SanFrancisco',
  fontSize: 20,
  letterSpacing: 0.1
);

const textFieldStyle = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
  prefixIcon: Icon(
    Icons.lock,
    color: Colors.white,
  ),
  hintText: 'Enter your Password',
  hintStyle: logHintStyle,
);

const logHintStyle = TextStyle(
  color: Colors.white38,
  fontFamily: 'SanFrancisco',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
import "package:flutter/material.dart";
import 'login_style.dart';

void popSnackBar(BuildContext context, String txt, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: Text(
                    txt, 
                    style: snackBarStyle
                  ),
                  backgroundColor: color,
                )
              ).closed
              .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }
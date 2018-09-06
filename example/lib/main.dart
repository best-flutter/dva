import 'package:example/main_generated.dart';
import 'package:example/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:dva/dva.dart';



// tes
void main() => runApp(new Dva(
      dvaBuilder: dvaBuilder,
      child: (BuildContext context) {
        return new MaterialApp(
          home: Dva.connect<HomePage>(context),
        );
      },
    ));





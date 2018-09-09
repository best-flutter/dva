import 'package:example/main.dva.dart';
import 'package:example/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:dva/dva.dart';

void main() => runApp(new BootApp(
      child: (BuildContext context) {
        return new MaterialApp(
          home: Boot.connect<HomePage>(context),
        );
      },
    ));

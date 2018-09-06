import 'package:flutter/material.dart';

import 'package:dva/dva.dart';


class HomePage extends StatelessWidget {
  HomePage(
      {Key key,
      @StateValue("counter") this.counter,
      @Dispatch("counter/add") this.onPress})
      : super(key: key);

  final Function onPress;

  final int counter;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Demo app"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this $counter many times:',
            ),
            new RaisedButton(onPressed: onPress)
          ],
        ),
      ),
    );
  }
}

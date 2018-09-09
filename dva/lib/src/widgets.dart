import 'dart:async';

import 'package:dva/src/boot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
typedef void ConnectWidget(BootRouter router);

typedef Widget ConnectorFactory(BuildContext context);
typedef Widget RouterPageBuilder(BuildContext context, dynamic param);


class BootRouter {
  final Map<String, RouterPageBuilder> _routers = {};

  Future<T> push<T>(BuildContext context, String name, dynamic param) {
    RouterPageBuilder builder = _routers[name];
    return Navigator.of(context).push(new MaterialPageRoute<T>(
        builder: (BuildContext context) {
          return builder(context, param);
        },settings: new RouteSettings(
      name: name
    )));
  }

  bool pop<T>(BuildContext context,[T result]){
    return Navigator.of(context).pop<T>(result);
  }

  Future<T> popUntilAndPush<T>(BuildContext context,{
    String popName,String pushName,dynamic param
  }){
    assert(pushName!=null);
    popUntil(context,popName);
    return push(context, pushName, param);
  }

  void popUntil(BuildContext context,[String name]){
    if(name==null){
      name = "";
    }
    Navigator.of(context).popUntil( (Route route){
      return route.settings.name == name;
    });
  }

  void register<T>({String name, RouterPageBuilder builder}) {
    _routers[name ?? ""] = builder;
    Boot.registerWidget<T>(builder);
  }
}
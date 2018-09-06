import 'dart:async';

import 'package:dva/dva.dart';
import 'package:example/models/CounterModel.dart';
import 'package:example/models/UserModel.dart';
import 'package:example/screens/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class A{

}

Map setupDvaModels(ModelProxy proxy) {
  UserModel userModel = new UserModel();
  proxy.registerSync("user/login", userModel.login);

  CounterModel counter = new CounterModel();
  proxy.registerSync(
      "counter/add", (int state, dynamic action) => counter.add(state));

  Map state = {
    userModel.getName(): userModel.getInitialState(),
    counter.getName(): counter.getInitialState()
  };
  return state;
}

dynamic dvaBuilder(BuildContext context, ModelProxy proxy,DvaRouter router) {

  router.register<HomePage>("",(BuildContext context,dynamic param){
    return new StoreBuilder<Map>(onInit: (Store<Map> store) {
      store.dispatch(new Action("user/login", {"title": ""}));
    }, builder: (BuildContext context, Store<Map> store) {
      return new HomePage(
        counter: store.state['counter'],
        onPress: wrapDispatch(store,"counter/add"),
      );
    });

  });

  //////// Handle models
  return setupDvaModels(proxy);
}

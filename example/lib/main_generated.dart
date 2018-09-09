import 'dart:async';

import 'package:dva/dva.dart';
import 'package:example/models/CounterModel.dart';
import 'package:example/models/UserModel.dart';
import 'package:example/screens/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


///Generate the app state
class AppState{
  UserState user;
  int counter;

  AppState({
    this.user,
    this.counter
  });
}

void $dvaCounterModel(DvaModels models,CounterModel model){
  models.registerSync("counter/add",justState<int>(model.add));
  models.registerSync("counter/sub",justState<int>(model.sub));
}



AppState setupDvaModels(DvaModels proxy) {
  UserModel userModel = new UserModel();
  CounterModel counter = new CounterModel();

  proxy.registerSync("user/login", userModel.login);
  proxy.registerSync(
      "counter/add", (int state, dynamic action) => counter.add(state));

  return new AppState(
    user: userModel.getInitialState(),
    counter: counter.getInitialState()
  );
}

dynamic dvaBuilder(BuildContext context, DvaModels model, DvaRouter router) {

  router.register<HomePage>(builder:(BuildContext context,dynamic param){
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

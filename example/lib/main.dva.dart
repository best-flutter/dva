import 'dart:async';

import 'package:dva/dva.dart';
import 'package:example/models/CounterModel.dart';
import 'package:example/models/UserModel.dart';
import 'package:example/screens/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// Generate the app state
class AppState extends MapState {
  UserState get user => this['user'];
  int get counter => this['counter'];

  AppState({UserState user, int counter})
      : super(data: {"user": user, "counter": counter});
}

/// Generate model
void $dvaCounterModel(BootModels models, CounterModel model) {
  models.registerSync("counter/add", justState(model.add));
  models.registerSync("counter/sub", justState(model.sub));
}

void $dvaUserModel(BootModels models, UserModel model) {
  models.registerSync("user/login", model.login);
}

/// Generate create App State
AppState _createAppState(BootModels proxy) {
  UserModel userModel = new UserModel();
  CounterModel counter = new CounterModel();

  $dvaCounterModel(proxy, counter);
  $dvaUserModel(proxy, userModel);

  return new AppState(
      user: userModel.getInitialState(), counter: counter.getInitialState());
}

void _connectWidget(BootRouter router) {
  // home page
  router.register<HomePage>(name:"",builder: (BuildContext context, dynamic param) {
    return new StoreBuilder<AppState>(onInit: (Store<AppState> store) {
      store.dispatch(new Action("user/login", {"title": ""}));
    }, builder: (BuildContext context, Store<AppState> store) {
      return new HomePage(
        counter: store.state.counter,
        onPress: wrapDispatch(store, "counter/add"),
      );
    });
  });
}

@immutable
class BootApp extends StatelessWidget {
  final WidgetBuilder child;

  BootApp({this.child});

  @override
  Widget build(BuildContext context) {
    return new Boot<AppState>(
      child: child,
      connectWidget: _connectWidget,
      stateFactory: _createAppState,
    );
  }
}

library dva;

import 'dart:async';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter/material.dart';

export 'package:dva_annotation/dva_annotation.dart';

abstract class Invoker<S> {
  S invoke(Store store, dynamic action);
}

abstract class BaseModel<T> {
  T getInitialState();

  Map<String,Function> getInvokers();

  String getName();
}

typedef Map<String,Function> modelBuilder<T>(T model);

typedef dynamic DvaBuilder(BuildContext context, ModelProxy modelProxy,DvaRouter router);

class ModelProxy {
  Map<String, Function> _stateMap = {};

  Map<String, Function> _asyncMap = {};

  ModelProxy();

  Map reduce(dynamic state, action) {
    String type = action.type;
    List<String> parts = type.split("/");
    if (parts.length != 2) {
      throw new Exception("A event name must be `modelName/modelFunction`");
    }
    String model = parts[0];
    Function invoker = _stateMap[type];
    var newState = invoker(state[model], action.payload);
    state[model] = newState;
    return state;
  }

  void registerSync(String key, Function func) {
    _stateMap[key] = func;
  }

  void registerAsync(String key, Function func) {
    _asyncMap[key] = func;
  }

  bool handleAsyncAction(
      Store<Map> store,
      dynamic action,
      ) {
    String type = action.type;
    Function invoker = _asyncMap[type];
    if (invoker == null) {
      return false;
    }
    invoker(store, action);
    return true;
  }
}


typedef Widget RouterPageBuilder(BuildContext context,dynamic param);

typedef Map<String,Function> ModelBuilder(dynamic model);

class DvaRouter{


  final Map<String,RouterPageBuilder> _routers = {};

  Future push(BuildContext context,String name,dynamic param){
    RouterPageBuilder builder = _routers[name];
    return Navigator.of(context).push(new MaterialPageRoute(builder:(BuildContext context){
      return builder(context,param);
    },settings: new RouteSettings(
        name: name,
        isInitialRoute: false
    )));
  }

  void register<T>(String name, RouterPageBuilder builder) {
    _routers[name] = builder;
    Dva.registerWidget<T>(name, builder);
  }

}

class Dva extends StatefulWidget {
  static Map<Type, RouterPageBuilder> _widgetConnectInfo = {};

  static Map<Type,ModelBuilder> _modelMap = {};

  static void registerWidget<T>(String name,RouterPageBuilder builder) {
    _widgetConnectInfo[T] = builder;
  }

  static void registerModel<T>(ModelBuilder builder){
    _modelMap[T] = builder;
  }

  static Widget connect<T>(BuildContext context,[dynamic param]) {
    RouterPageBuilder builder = _widgetConnectInfo[T];
    return builder(context,param);
  }

  final WidgetBuilder child;

  final DvaBuilder dvaBuilder;

  final List<Middleware> middlewares;


  Dva({this.child, this.dvaBuilder,this.middlewares});

  @override
  State<StatefulWidget> createState() {
    return new _DvaState();
  }
}




class _DvaState extends State<Dva> {

  Store<Map> store;


  final ModelProxy proxy = new ModelProxy();
  final DvaRouter router = new DvaRouter();

  @override
  void initState() {
    dynamic state = widget.dvaBuilder(context, proxy,router);
    store = createStore(proxy, state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Map>(store: store, child: widget.child(context));
  }
}

class Action {
  final String type;
  final dynamic payload;

  Action(this.type, [this.payload]);
}

Function wrapDispatch(Store store, String event) {
  return ([payload]) => store.dispatch(new Action(event, payload));
}

Store<Map> createStore(ModelProxy proxy, Map initialState) {
  Store<Map> store = new Store<Map>((Map state, dynamic action) {
    return proxy.reduce(state, action);
  }, initialState: initialState, middleware: [
        (
        Store<Map> store,
        dynamic action,
        NextDispatcher next,
        ) {
      if (proxy.handleAsyncAction(store, action)) {
        return;
      }
      next(action);
    }
  ]);
  return store;
}


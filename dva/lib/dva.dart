library dva;
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

export 'package:dva_annotation/dva_annotation.dart';

typedef S StateReducer<S>(S state,dynamic action);

typedef StateReducer<S> SyncReducerAdapter<S>(Function func);


StateReducer<S> justState<S>(Function func){
  return (S state,dynamic action){
    return func(state);
  };
}





abstract class ValueAdapter{
  dynamic adapt(dynamic value);
}

class Map2NamedParameterAdapter implements ValueAdapter{
  @override
  adapt(value) {
    return Map();
  }
}

class Action2PayloadAdapter implements ValueAdapter{
  @override
  adapt(value) {
    return value.payload;
  }
}



abstract class Invoker<S> {
  S invoke(Store store, dynamic action);
}

abstract class BaseModel<T> {
  T getInitialState();

  Map<String,Function> getInvokers();
}

typedef Map<String,Function> modelBuilder<T>(T model);

typedef dynamic DvaBuilder(BuildContext context, DvaModels modelProxy,DvaRouter router);

class DvaModels {
  Map<String, Function> _stateMap = {};

  Map<String, Function> _asyncMap = {};

  Map<Type,Function> _modelEvent = {};

  DvaModels();

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

  void registerModelEvent<T>(Function func){
    _modelEvent[T] = func;
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

  void register<T>({
    String name, RouterPageBuilder builder
  }) {
    _routers[name] = builder;
    Dva.registerWidget<T>(builder);
  }

}

class Dva extends StatefulWidget {
  static Map<Type, RouterPageBuilder> _widgetConnectInfo = {};

  static Map<Type,ModelBuilder> _modelMap = {};

  static void registerWidget<T>(RouterPageBuilder builder) {
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


  final DvaModels proxy = new DvaModels();
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

Store<Map> createStore(DvaModels proxy, Map initialState) {
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


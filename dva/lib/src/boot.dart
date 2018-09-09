import 'package:dva/src/models.dart';
import 'package:dva/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';



class Boot<S extends MapState> extends StatefulWidget {
  static Map<Type, RouterPageBuilder> _widgetConnectInfo = {};

  static void registerWidget<T>(RouterPageBuilder builder) {
    _widgetConnectInfo[T] = builder;
  }

  static Widget connect<T>(BuildContext context, [dynamic param]) {
    RouterPageBuilder builder = _widgetConnectInfo[T];
    return builder(context, param);
  }

  final WidgetBuilder child;

  final List<Middleware> middlewares;

  final ConnectWidget connectWidget;

  final StateFactory<S> stateFactory;

  Boot({this.child, this.middlewares, this.stateFactory, this.connectWidget});

  @override
  State<StatefulWidget> createState() {
    return new _BootState<S>();
  }
}

class _BootState<S extends MapState> extends State<Boot<S>> {
  Store<S> store;

  final BootModels<S> proxy = new BootModels<S>();
  final BootRouter router = new BootRouter();


  void _runAsync(
      Store<S> store,
      dynamic action,
      NextDispatcher next,
      ) {
    if (proxy.handleAsyncAction(store, action)) {
      return;
    }
    next(action);
  }

  Store<S> _createStore(BootModels<S> proxy, S initialState) {
    Store<S> store = new Store<S>((S state, dynamic action) {
      return proxy.reduce(state, action);
    }, initialState: initialState, middleware: [_runAsync]);
    return store;
  }

  @override
  void initState() {
    widget.connectWidget(router);
    dynamic state = widget.stateFactory(proxy);
    store = _createStore(proxy, state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<S>(store: store, child: widget.child(context));
  }
}

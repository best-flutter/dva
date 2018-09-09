import 'package:dva/src/actions.dart';
import 'package:redux/redux.dart';




abstract class BaseModel<T> {
  T getInitialState();
}



typedef S StateFactory<S extends MapState>(BootModels<S> modelHolder);

Function justState(Function func) {
  return (any, action) {
    return func(any);
  };
}

Function adapter<T>(Function func) {
  return (any, action) {
    if (action is T) {
      return func(any, action);
    }

    //T is not a Action, a payload must be passed
    if (action is Action) {
      if (action.payload is T) {
        return func(any, action.payload);
      }
      // if we can cast the payload to T , is their any way to do this ?
      throw new Exception(
          "Un supported action $action, payload cannot cast to $T");
    }

    throw new Exception("Un supported action $action, cannot cast to $T");
  };
}

Function map2NamedParameter(Function func) {
  return (any, Action action) {
    Map<Symbol, dynamic> newMap = {};
    Map payload = action.payload;
    payload.forEach((k, v) => newMap[new Symbol(k)] = v);
    return Function.apply(func, [any], newMap);
  };
}



class MapState {
  Map<String, dynamic> _data;

  MapState({Map<String, dynamic> data}) : _data = data;

  dynamic operator [](String key) {
    return _data[key];
  }

  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }
}

class BootModels<S extends MapState> {
  Map<String, Function> _stateMap = {};

  Map<String, Function> _asyncMap = {};

  Map<Type, Function> _modelEvent = {};

  BootModels();

  S reduce(S state, Action action) {
    String type = action.type;
    List<String> parts = type.split("/");
    if (parts.length != 2) {
      throw new Exception("A event name must be `modelName/modelFunction`");
    }
    String model = parts[0];
    Function invoker = _stateMap[type];
    var newState = invoker(state[model], action);
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
    Store<S> store,
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

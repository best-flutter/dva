import 'dart:async';

import 'package:dva/dva.dart';
import 'package:example/main.dva.dart';
import 'package:redux/redux.dart';

@Model("counter")
class CounterModel extends BaseModel<int> with $CounterModel {
  @override
  int getInitialState() {
    return 0;
  }

  /// First argument is the current state
  ///
  int add(int counter) {
    return counter + 1;
  }

  int sub() {}

  Future asyncAdd(Store<AppState> store, dynamic action) {
    AppState state = store.state;
  }
}

class $CounterModel {
  Map<String, Function> getInvokers() {
    return {};
  }

  String getName() {
    return "counter";
  }
}

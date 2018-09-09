
import 'package:dva/src/actions.dart';
import 'package:redux/redux.dart';

Function wrapDispatch(Store store, String event) {
  return ([payload]) => store.dispatch(new Action(event, payload));
}

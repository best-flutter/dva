import 'package:dva/dva.dart';


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

  int sub(){

  }
}


class $CounterModel{

  Map<String,Function> getInvokers(){
    return {

    };
  }

  String getName() {
    return "counter";
  }
}
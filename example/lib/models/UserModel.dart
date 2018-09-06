import 'package:dva/dva.dart';

class UserState {

}

class UserModel extends BaseModel<UserState> {
  UserState login(UserState state, dynamic action) {
   // print('test $action ${new DateTime.now()}');
    return state;
  }

  @override
  UserState getInitialState() {
    return new UserState();
  }

  @override
  String getName() {
    return "name";
  }

  @override
  Map<String, Function> getInvokers() {
    // TODO: implement getInvokers
  }
}

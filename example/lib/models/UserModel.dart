import 'package:dva/dva.dart';

class UserState {

}

@Model("user")
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
  Map<String, Function> getInvokers() {
    // TODO: implement getInvokers
  }
}

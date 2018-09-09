import 'package:dva/dva.dart';

class UserState {}

@Model("user")
class UserModel extends BaseModel<UserState> {
  UserState login(UserState state, dynamic action) {
    return state;
  }

  @override
  UserState getInitialState() {
    return new UserState();
  }
}

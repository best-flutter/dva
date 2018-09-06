library dva_annotation;


class StateValue {
  final String name;
  const StateValue(this.name);
}

class Parameter {
  final String name;
  const Parameter(this.name);
}

/// @push/name
/// @pop
/// @popUntil
class Dispatch {
  final String name;
  const Dispatch(this.name);
}

class OnInit {
  final String type;
  final dynamic data;
  const OnInit(this.type, {this.data});
}

class Router {
  final String path;
  const Router(this.path);
}

class Model {
  final String name;
  const Model(this.name)
      : assert(name != null, "A valid name must be provided");
}



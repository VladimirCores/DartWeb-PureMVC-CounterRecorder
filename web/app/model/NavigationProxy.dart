import 'package:framework/framework.dart';

import 'vos/RouteVO.dart';

class NavigationProxy extends Proxy {
  static const String NAME = "NavigationProxy";

  List<RouteVO> _stack = [];
  RouteVO currentRoute;

  NavigationProxy() : super( NAME ) {
	  print(">\t NavigationProxy -> instance created");
  }

  void addToStack(RouteVO page) {
    _stack.add(page);
    print(">\t NavigationProxy -> _stack size " + _stack.length.toString());
  }

  RouteVO popFromStack() {
    return _stack.isNotEmpty ? _stack.removeLast() : null;
  }
}
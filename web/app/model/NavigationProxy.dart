import 'package:framework/framework.dart';

import 'vos/RouteVO.dart';

class NavigationProxy extends Proxy {
  static const String NAME = "NavigationProxy";

  final List<RouteVO> _stack = [];
  final Map<String, Mediator> _pagesMediators =  Map<String, Mediator>();
  RouteVO currentRoute;

  void registerPageMediator( String path, Mediator mediator ) {
    _pagesMediators[path] = mediator;
  }

  NavigationProxy() : super( NAME ) {
	  print(">\t NavigationProxy -> instance created");
  }

  void addToStack( RouteVO page ) {
    _stack.add(page);
    print(">\t NavigationProxy -> _stack size " + _stack.length.toString());
  }

  bool currentRouteIs(String path) => this.currentRoute.path.compareTo(path) == 0;

  RouteVO popFromStack() {
    return _stack.isNotEmpty ? _stack.removeLast() : null;
  }

  Mediator getPageMediator(String path) => _pagesMediators[path];
  Mediator getCurrentRoutePageMediator() => _pagesMediators[currentRoute.path];
}

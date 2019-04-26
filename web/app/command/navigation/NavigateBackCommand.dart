import 'package:framework/framework.dart';

import '../../../consts/Routes.dart';
import '../../../consts/commands/NavigationCommand.dart';
import '../../model/NavigationProxy.dart';
import '../../model/vos/RouteVO.dart';

class NavigateBackCommand extends SimpleCommand {
	@override
	void execute( INotification note ) {
		final NavigationProxy navigationProxy = facade.retrieveProxy( NavigationProxy.NAME );
		RouteVO routeVO = navigationProxy.popFromStack();
		print("> NavigateBackCommand -> routeVO: $routeVO");
		var routeName = routeVO != null ? routeVO.name : Routes.DEFAULT;
		sendNotification( NavigationCommand.NAVIGATE_TO_PAGE, true, routeName );
	}
}

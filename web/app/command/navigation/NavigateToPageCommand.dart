import 'package:framework/framework.dart';

import '../../../consts/Routes.dart';
import '../../../consts/notification/ApplicationNotification.dart';
import '../../model/NavigationProxy.dart';
import '../../model/vos/RouteVO.dart';
import '../../view/mediator/pages/HistoryPageMediator.dart';
import '../../view/mediator/pages/HomePageMediator.dart';

class NavigateToPageCommand extends SimpleCommand {
	@override
	void execute( INotification note ) {
		final route = note.getType();
		final isBack = note.getBody();
		print("> NavigateToPageCommand > route: $route $isBack");
		final NavigationProxy navigationProxy = facade.retrieveProxy( NavigationProxy.NAME );

		if (navigationProxy.currentRoute != null && !isBack)
				navigationProxy.addToStack(
					navigationProxy.currentRoute);

		var mediatorName;
		switch (route) {
			case Routes.HISTORY_SCREEN: mediatorName = HistoryPageMediator.NAME; break;
			case Routes.HOME_SCREEN: mediatorName = HomePageMediator.NAME; break;
			default: mediatorName = HomePageMediator.NAME;
		}
		final pageMediator = facade.retrieveMediator( mediatorName );
		final page = pageMediator.getViewComponent();

		navigationProxy.currentRoute = new RouteVO(0, route);

		sendNotification( ApplicationNotification.NAVIGATE_TO_PAGE, page );
	}
}

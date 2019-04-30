import 'package:framework/framework.dart';

import '../../../consts/notification/ApplicationNotification.dart';
import '../../model/NavigationProxy.dart';
import '../../model/vos/RouteVO.dart';

class NavigateToPageCommand extends SimpleCommand {
	@override
	void execute( INotification note ) {
		final path = note.getType();
		final isBack = note.getBody();
		print("> NavigateToPageCommand > route: $path $isBack");
		final NavigationProxy navigationProxy = facade.retrieveProxy( NavigationProxy.NAME );

		if ( navigationProxy.currentRoute != null ) {
			if (!isBack) navigationProxy.addToStack( navigationProxy.currentRoute );

			final pageFromMediator = navigationProxy.getCurrentRoutePageMediator();
			final pageFrom = pageFromMediator.getViewComponent();
			sendNotification( ApplicationNotification.NAVIGATE_FROM_PAGE, pageFrom );
			print("> NavigateToPageCommand > facade.removeMediator: ${pageFromMediator.getName()}");
			facade.removeMediator( pageFromMediator.getName() );
		}

		final pageToMediator = navigationProxy.getPageMediator( path );
		final pageTo = pageToMediator.getViewComponent();

		facade.registerMediator( pageToMediator );
		navigationProxy.currentRoute = new RouteVO(0, path);

		sendNotification( ApplicationNotification.NAVIGATE_TO_PAGE, pageTo );
	}
}

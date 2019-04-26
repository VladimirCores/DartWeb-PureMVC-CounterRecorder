import 'package:framework/framework.dart';

import '../../view/components/Application.dart';
import '../../view/components/pages/HistoryPage.dart';
import '../../view/components/pages/HomePage.dart';
import '../../view/mediator/ApplicationMediator.dart';
import '../../view/mediator/pages/HistoryPageMediator.dart';
import '../../view/mediator/pages/HomePageMediator.dart';

class PrepareViewCommand extends SimpleCommand {
  @override
  void execute( INotification note ) {
    print("> StartupCommand -> PrepareViewCommand > note: $note");

    final ApplicationMediator applicationMediator = ApplicationMediator();
    final HomePageMediator homeScreenMediator = HomePageMediator();
    final HistoryPageMediator historyScreenMediator = HistoryPageMediator();

    final HomePage homeScreen = HomePage();
    final HistoryPage historyScreen = HistoryPage();

    final Application application = note.getBody() as Application;
// = new Application(
//      observers: <NavigatorObserver>[
//      	homeScreen.routeObserver
//	    , historyScreen.routeObserver
//      ],
//		  routes: {
//			  Routes.HOME_SCREEN: ( BuildContext context ) => homeScreen,
//			  Routes.LOGIN_SCREEN: ( BuildContext context ) => loginScreen,
//			  Routes.HISTORY_SCREEN: ( BuildContext context ) => historyScreen,
//		  },
//		  initialRoute: Routes.HOME_SCREEN
//	  );

    applicationMediator.setViewComponent( application );
    homeScreenMediator.setViewComponent( homeScreen );
    historyScreenMediator.setViewComponent( historyScreen );

    facade.registerMediator( applicationMediator );
    facade.registerMediator( homeScreenMediator );
    facade.registerMediator( historyScreenMediator );
  }
}
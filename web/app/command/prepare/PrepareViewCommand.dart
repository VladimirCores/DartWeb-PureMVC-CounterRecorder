import 'package:framework/framework.dart';

import '../../../consts/Routes.dart';
import '../../model/NavigationProxy.dart';
import '../../view/components/Application.dart';
import '../../view/components/pages/HistoryPage.dart';
import '../../view/components/pages/HomePage.dart';
import '../../view/mediator/ApplicationMediator.dart';
import '../../view/mediator/pages/HistoryPageMediator.dart';
import '../../view/mediator/pages/HomePageMediator.dart';

class PrepareViewCommand extends SimpleCommand {
  @override
  void execute(INotification note) {
    print("> StartupCommand -> PrepareViewCommand > note: $note");

    final navigationProxy = facade.retrieveProxy(NavigationProxy.NAME) as NavigationProxy;

    final ApplicationMediator applicationMediator = ApplicationMediator();
    final HomePageMediator homePageMediator = HomePageMediator();
    final HistoryPageMediator historyPageMediator = HistoryPageMediator();

    final Application application = note.getBody() as Application;

    final HomePage homeScreen = HomePage();
    final HistoryPage historyScreen = HistoryPage();

    applicationMediator.setViewComponent(application);
    homePageMediator.setViewComponent(homeScreen);
    historyPageMediator.setViewComponent(historyScreen);

    navigationProxy.registerPageMediator(Routes.HOME_PAGE, homePageMediator);
    navigationProxy.registerPageMediator(Routes.HISTORY_PAGE, historyPageMediator);

    facade.registerMediator(applicationMediator);
  }
}

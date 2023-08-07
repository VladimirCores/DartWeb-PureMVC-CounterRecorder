import 'package:framework/framework.dart';

import '../../../consts/notification/ApplicationNotification.dart';
import '../components/Application.dart';
import '../components/base/DomElement.dart';

class ApplicationMediator extends Mediator {
  static const String NAME = "ApplicationMediator";

  ApplicationMediator() : super(NAME);

  @override
  void onRegister() {
    print(">\t ApplicationMediator -> onRegister");
    application.show();
  }

  @override
  void onRemove() {}

  @override
  List<String> listNotificationInterests() {
    return [ApplicationNotification.NAVIGATE_TO_PAGE, ApplicationNotification.NAVIGATE_FROM_PAGE];
  }

  @override
  void handleNotification(INotification note) {
    print("> ApplicationMediator -> handleNotification: note.name = ${note.getName()}");
    final DomElement page = note.getBody();
    print("> \t\t page = ${page}");
    switch (note.getName()) {
      case ApplicationNotification.NAVIGATE_FROM_PAGE:
        application.removeElement(page, hideFromDom: true);
        break;
      case ApplicationNotification.NAVIGATE_TO_PAGE:
        application.addElement(page, appendToDom: true);
        page.show();
        break;
    }
  }

  Application get application => getViewComponent() as Application;
}

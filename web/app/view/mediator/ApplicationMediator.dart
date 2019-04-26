import 'package:framework/framework.dart';

import '../../../consts/notification/ApplicationNotification.dart';
import '../components/Application.dart';
import '../components/base/DomElement.dart';

class ApplicationMediator extends Mediator {

	static const String NAME = "ApplicationMediator";

	ApplicationMediator() : super( NAME );

	@override
	void onRegister() {
		print(">\t ApplicationMediator -> onRegister");
	}

	@override
	void onRemove() {

	}

	@override
	List<String> listNotificationInterests() {
		return [
			ApplicationNotification.NAVIGATE_TO_PAGE
		];
	}

	@override
	void handleNotification( INotification note ) {
		print("> ApplicationMediator -> handleNotification: note.name = ${note.getName()}");
		switch( note.getName() ) {
			case ApplicationNotification.NAVIGATE_TO_PAGE:
				final DomElement page = note.getBody();
				application.replacePage(page);
				application.show();
				break;
		}
	}

	Application get application => getViewComponent() as Application;
}
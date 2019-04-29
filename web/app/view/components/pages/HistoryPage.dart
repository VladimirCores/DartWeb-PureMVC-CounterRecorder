import 'dart:async';
import 'dart:html';

import '../base/DomElement.dart';

class HistoryPage extends DomElement
{
	final ButtonElement navigateButton = ButtonElement();

	HistoryPage() : super( null, Element.div() ) {
		navigateButton.className = "NavigateButton NavigateBackButton";
		navigateButton.text = "< BACK";

		this.addChild(navigateButton);
	}

	final StreamController _revertHistoryItemConfirmed = StreamController.broadcast();

	Stream get onNavigationBackButtonPressed => EventStreamProvider<Event>('click').forTarget(navigateButton);
	Stream get onRevertHistoryItemButtonPressed => _revertHistoryItemConfirmed.stream;

  void showPreloader() {

	}
}

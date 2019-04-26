import 'dart:async';
import 'dart:html';

import '../../base/DomElement.dart';

class HistoryItem extends DomElement
{
	final ButtonElement deleteButton = ButtonElement();
	final DivElement counterText = Element.div();
	final DivElement actionText = Element.div();

	HistoryItem(action, time, value) : super( null, Element.div() ) {
		deleteButton.className = "HistoryItem_DeleteButton";
		deleteButton.text = "delete";
    counterText.text = value;
    actionText.text = action;
		this.addChild(deleteButton);
		this.addChild(counterText);
		this.addChild(actionText);
	}

	Stream get onNavigationBackButtonPressed => EventStreamProvider<Event>('click').forTarget(deleteButton);
}

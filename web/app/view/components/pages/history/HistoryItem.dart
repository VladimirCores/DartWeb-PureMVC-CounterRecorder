import 'dart:async';
import 'dart:html';

import '../../base/DomElement.dart';

class HistoryItem extends DomElement
{
	final ButtonElement deleteButton = ButtonElement();
	final ButtonElement restoreButton = ButtonElement();
	final SpanElement timeText = Element.span();
	final SpanElement valueText = Element.span();
	final SpanElement actionText = Element.span();

	final key;

	HistoryItem(this.key, String action, String time, String value) : super(null, Element.div() ) {
		deleteButton.text = "delete";
		restoreButton.text = "revert";
    timeText.text = time;
    valueText.text = value;
    actionText.text = action;
		valueText.className = "HistoryItem-Value";
		actionText.className = "HistoryItem-Action";
		timeText.className = "HistoryItem-Time";
		this.addChild(valueText);
		this.addChild(timeText);
		this.addChild(actionText);
		this.addChild(deleteButton);
		this.addChild(restoreButton);
	}

	Stream get onDeleteButtonPressed => EventStreamProvider<Event>('click').forTarget(deleteButton);
	Stream get onRevertButtonPressed => EventStreamProvider<Event>('click').forTarget(restoreButton);
}

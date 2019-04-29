import 'dart:html';

import '../../base/DomElement.dart';

class HistoryList extends DomElement
{
	static final String _DISABLED_CLASS_NAME = ' disabled';

	HistoryList() : super( null, Element.div() ) {
		this.dom.className = "HistoryList";
	}

	void removeListElementByIndex(int value) {
		DomElement element = this.domElements[ value ];
		this.removeElement(element);
		element.dispose();
	}

  void disable() {
		this.dom.className += _DISABLED_CLASS_NAME;
	}

  void enabled() {
		this.dom.className = this.dom.className.replaceFirst(_DISABLED_CLASS_NAME, '');
	}
}

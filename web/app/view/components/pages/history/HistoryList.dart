import 'dart:html';

import '../../base/DomElement.dart';

class HistoryList extends DomElement
{
	static final String _DISABLED_CLASS_NAME = ' disabled';

	HistoryList() : super( null, Element.div() );

	void removeListElementByIndex(int value) {
		DomElement element = this.domElements[ value ];
		this.removeElement( element );
		element.dispose();
	}

	int getChildIndex( node ) {
		return this.dom.children.indexOf( node );
	}

  void disable() {
		this.dom.className += _DISABLED_CLASS_NAME;
	}

  void enabled() {
		var cn = this.dom.className;
		this.dom.className = cn.replaceFirst(_DISABLED_CLASS_NAME, '');
	}
}

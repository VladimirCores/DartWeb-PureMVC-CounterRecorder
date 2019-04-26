import 'dart:html';

import '../../base/DomElement.dart';

class HistoryList extends DomElement
{
	HistoryList() : super( null, Element.div() ) {
		this.dom.className = "HistoryList";
	}
}

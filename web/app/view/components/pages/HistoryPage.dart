import 'dart:html';

import '../base/DomElement.dart';
import 'history/HistoryPreloader.dart';

class HistoryPage extends DomElement
{
	final ButtonElement navigateButton = ButtonElement();

	HistoryPreloader _historyPreloader;

	HistoryPage() : super( null, Element.div() ) {
		navigateButton.className = "NavigateButton NavigateBackButton";
		navigateButton.text = "< BACK";
		this.addDOMChild(navigateButton);
	}

  void showPreloader() {
		if ( _historyPreloader != null ) hidePreloader();
		_historyPreloader = new HistoryPreloader( this.dom );
		this.addElement( _historyPreloader, appendToDom: true );
	}

	void hidePreloader() {
		this.removeElement( _historyPreloader );
		_historyPreloader.dispose();
		_historyPreloader = null;
	}
}

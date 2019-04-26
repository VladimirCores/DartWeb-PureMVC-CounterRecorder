import 'dart:async';
import 'dart:html';

import '../base/DomElement.dart';

class HomePage extends DomElement
{
	final ButtonElement plusButton = ButtonElement();
	final ButtonElement minusButton = ButtonElement();
	final ButtonElement navigateButton = ButtonElement();

	final DivElement counterText = Element.div();

	HomePage() : super( null, Element.div() ){
		plusButton.className = "CounterButton PlusButton";
		plusButton.text = "+";

		minusButton.className = "CounterButton MinusButton";
		minusButton.text = "-";

		counterText.className = "CounterText Center";

		navigateButton.className = "NavigateButton NavigateToHistoryButton";
		navigateButton.text = "HISTORY";

		this.addChild(plusButton);
		this.addChild(minusButton);
		this.addChild(counterText);
		this.addChild(navigateButton);
	}

	void setCounter( int value ) {
		counterText.text = value.toString();
	}

	Stream get onIncrementButtonPressed => EventStreamProvider<Event>('click').forTarget(plusButton);
	Stream get onDecrementButtonPressed => EventStreamProvider<Event>('click').forTarget(minusButton);
	Stream get onNavigateHistoryButtonPressed => EventStreamProvider<Event>('click').forTarget(navigateButton);
}

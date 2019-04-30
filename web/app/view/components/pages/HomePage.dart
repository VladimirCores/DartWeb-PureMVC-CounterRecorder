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

		this.addDOMChild(plusButton);
		this.addDOMChild(minusButton);
		this.addDOMChild(counterText);
		this.addDOMChild(navigateButton);
	}

	void setCounter( int value ) {
		counterText.text = value.toString();
	}
}

import 'dart:html';

import '../../base/DomElement.dart';

class HistoryItem extends DomElement {
  static const String ID_BUTTON_DELETE = "btnDelete";
  static const String ID_BUTTON_RESTORE = "btnRevert";

  final ButtonElement deleteButton = ButtonElement();
  final ButtonElement restoreButton = ButtonElement();
  final timeText = Element.span() as SpanElement;
  final valueText = Element.span() as SpanElement;
  final actionText = Element.span() as SpanElement;

  final key;

  HistoryItem(Element parent, this.key, String action, String time, String value) : super(parent, Element.div()) {
    deleteButton.text = "delete";
    restoreButton.text = "revert";
    deleteButton.id = ID_BUTTON_DELETE;
    restoreButton.id = ID_BUTTON_RESTORE;
    timeText.text = time;
    valueText.text = value;
    actionText.text = action;
    valueText.className = "HistoryItem-Value";
    actionText.className = "HistoryItem-Action";
    timeText.className = "HistoryItem-Time";
    this.addDOMChild(valueText);
    this.addDOMChild(timeText);
    this.addDOMChild(actionText);
    this.addDOMChild(deleteButton);
    this.addDOMChild(restoreButton);
  }

  void lock() {
    deleteButton.disabled = true;
    restoreButton.disabled = true;
  }
}

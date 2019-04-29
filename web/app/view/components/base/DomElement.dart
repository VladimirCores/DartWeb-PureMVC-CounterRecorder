import 'dart:async';
import 'dart:html';

abstract class DomElement {

  Element dom;
  Element parent;
  List<DomElement> domElements;

	StreamController _onShown = StreamController.broadcast();
	Stream get onShown => _onShown.stream;

  StreamController _onHidden = StreamController.broadcast();
	Stream get onHidden => _onHidden.stream;

  DomElement(parent, dom) {
    this.parent = parent;
    this.dom = dom;
    this.domElements = [];
    this.dom.className = this.runtimeType.toString();
  }

  void addChild(element) { this.dom.children.add(element); }
  void addElement(DomElement element) {
    this.domElements.add(element);
    element.changeParent(this.dom);
  }
  void removeElement(element) {
    this.domElements.remove(element);
  }

  void changeParent(parent) {
    this.parent = parent;
    if (parent != null)
      this.show();
  }

  void deselect() { /* abstract */ this.domElements.forEach((domElement) => domElement.deselect());  }
  void select() { /* abstract */ this.domElements.forEach((domElement) => domElement.select());  }
  void update(data) { /* abstract */ this.domElements.forEach((domElement) => domElement.update(data)); }

  void show() {
    this.domElements.forEach((domElement) => domElement.show());
    this.parent.append(this.dom);
    _onShown.add(this.dom);
  }

  void hide() {
    this.dom.remove();
    _onHidden.add(this.dom);
  }

  void dispose() {
    if (this.dom.parentNode != null)
      this.hide();

    _onShown.close();
    _onShown = null;
    _onHidden.close();
    _onHidden = null;
    this.domElements = [];
    this.dom = null;
    this.parent = null;
  }
}
